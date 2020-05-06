#!/bin/bash               
######################################################################################################################################
# 
# Date:        XX-Abr-2020  
# Author:      Pablo Javier Abdala
# Description: 
#                    
#   
####################################################################################################################################

# Global definitions
TRANSFERTMP=$$
HOSTDEF=`hostname`
DATEFORMAT=`date "+%Y%m%d%H%M%S"`
DATEFORMAT1=`date "+%Y%m%d"`
DATEFORMAT2=`date -d "2 days ago" "+%Y%m%d"` # Date used to cleanup the processed files.
DESTINATIONFILE=/home/iumadmin/scripts/DestinationInformation.csv
LOG=/var/opt/SIU/log/DeliveryAgent_$DATEFORMAT1.txt
SERVICIO=$1
IPDESTINO=$2
ARCHIVOTMP=$(mktemp)
FTPLOG=$(mktemp)
FLAGPROCESADOS=0

if [ $# -lt 2 ]; then   # Validate parameters
  echo $DATEFORMAT"|||||ERROR|900|Parameters are missing in the scheduled JOB">> $LOG
  exit
fi

RUNNING=`ps -ef | grep -w $1 | grep $2  | grep -v grep | wc -l` # Check that the script is not running

if [ $RUNNING -gt 3 ]; then
  echo $DATEFORMAT"|"$SERVICIO"|||"$IPDESTINO"|ERROR|901|The job for $SERVICIO and the destination IP $IPDESTINO is already running">> $LOG
  exit
fi

LINE=`grep -w $SERVICIO $DESTINATIONFILE | grep -w $IPDESTINO` # OBTAIN DELIVERY INFORMATION FROM DestinationInformation.csv

if [[ $LINE == "" ]]; then                # Validate if there are information for the JOB
  echo $DATEFORMAT"|"$SERVICIO"|||"$IPDESTINO"|ERROR|902|There is no information in DestinationInformation.csv for the service $SERVICIO and the destination IP $IPDESTINO" >> $LOG 
  exit
fi 

ORIGIN=`awk -F \| '{print $2}'  <<< "$LINE"`
MASK=`awk -F \| '{print $3}'  <<< "$LINE"`
USER=`awk -F \| '{print $5}'  <<< "$LINE"`
PASSWD=`awk -F \| '{print $6}'  <<< "$LINE"`
RETRIES=`awk -F \| '{print $7}'  <<< "$LINE"`
WAITTIME=`awk -F \| '{print $8}'  <<< "$LINE"`
WAITTIME=$( expr $WAITTIME \* 60 )
DESTINATION=`awk -F \| '{print $9}'  <<< "$LINE"`
STATUS=0

ARCHIVOCONTROL=$ORIGIN/$SERVICIO\_$IPDESTINO

if [[ $MASK == *,* ]]; then           #List the files to transfer
    MASKS=$(echo $MASK | tr "," "\n")
    for X in $MASKS
    do
      ARCHIVOS+=`ls -tr $ORIGIN/$X 2>/dev/null`
      ARCHIVOS+=" "
    done
  else
    ARCHIVOS=`ls -tr $ORIGIN/$MASK 2>/dev/null`
fi

if [[ $ARCHIVOS != "" ]]; then   #Check for files to transfer
  for ARCHIVO in $ARCHIVOS       #Start transferring files
  do
    STATUS=0
    ARCHIVOBASE=`basename $ARCHIVO`
    PROCESADO=`grep $ARCHIVOBASE $ARCHIVOCONTROL 2>/dev/null | wc -l` 
    
    if [ $PROCESADO == 0 ]; then  #Validate that it has not been previously transferred
      RETRY=1
      TRANSFERED=0
      FLAGPROCESADOS=1
      cp $ARCHIVO $ARCHIVO.$TRANSFERTMP         #Prepare transfer 
      echo open $IPDESTINO > $ARCHIVOTMP
      echo user $USER $PASSWD >> $ARCHIVOTMP
      echo binary >> $ARCHIVOTMP
      echo put $ARCHIVO.$TRANSFERTMP $DESTINATION/$ARCHIVOBASE.$TRANSFERTMP >> $ARCHIVOTMP
      echo chmod 666 $DESTINATION/$ARCHIVOBASE.$TRANSFERTMP >> $ARCHIVOTMP 
      echo rename $DESTINATION/$ARCHIVOBASE.$TRANSFERTMP $DESTINATION/$ARCHIVOBASE >> $ARCHIVOTMP
      echo quit >> $ARCHIVOTMP
       #Do the transfer
      while [[ $TRANSFERED == 0  && ( $RETRY -le $RETRIES  ||  $RETRIES -eq -1 ) ]] #Control retries and transfer
        do
          ftp -inv < $ARCHIVOTMP > $FTPLOG
          ERRORCODE=`egrep -wc "^230|^226|^200|^250" $FTPLOG`          
          DATEFORMAT=`date "+%Y%m%d%H%M%S"`
          case $ERRORCODE in 
            5) 
                echo $DATEFORMAT"|"$SERVICIO"|"$ORIGIN"|"$IPDESTINO"|INFO|"$ERRORCODE"|The file $ARCHIVOBASE was transfered to "$DESTINATION" on server IP "$IPDESTINO >> $LOG
                rm $ARCHIVO.$TRANSFERTMP
                echo $DATEFORMAT1\_$ARCHIVOBASE >> $ARCHIVOCONTROL #Register the transferred file 
                TRANSFERED=1;;
            *)
                echo $DATEFORMAT"|"$SERVICIO"|"$ORIGIN"|"$IPDESTINO"|ERROR|"$ERRORCODE"|Could not transfer file $ARCHIVOBASE" >> $LOG
                if [ $RETRY != $RETRIES ]; then
                  sleep $WAITTIME
                else
                  rm $ARCHIVO.$TRANSFERTMP
                fi
                ((RETRY++));;
              esac
        done    
    fi
  done 
fi                                                                  

if [ $FLAGPROCESADOS == 0 ]; then  #Registry no new files to transfer
  echo $DATEFORMAT"|"$SERVICIO"|"$ORIGIN"|"$IPDESTINO"|INFO|1|There are no files to transfer" >> $LOG
fi

awk -F _ -v fecha=$DATEFORMAT2  '$1 > fecha' $ARCHIVOCONTROL > $ARCHIVOCONTROL.tmp # Remove old files from the processed list
mv $ARCHIVOCONTROL.tmp $ARCHIVOCONTROL
   
rm -f $ARCHIVOTMP  # Remove temporary files
rm -f $FTPLOG
