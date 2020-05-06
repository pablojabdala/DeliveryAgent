#!/bin/sh
 
HOSTSERVER=`hostname` 
TRICK="X"
echo $HOSTSERVER

SITE_AUX=`echo $HOSTSERVER | sed s/ium2/ium/`
SERVERSLIST=""
LAB=0

NUM_IUM_INST=8
case ${HOSTSERVER} in
rjmte03ium2|spcas01ium2|rjmte01ium2|spcas02ium2)
	NUM_IUM_INST=10
;;
* )
	NUM_IUM_INST=8
esac

case ${HOSTSERVER} in
pcrflab2)
	SERVERSLIST="pcrflab2"
		LAB=1
;;
pcrflab3)
	SERVERSLIST="pcrflab3"	
	LAB=1
;;
pcrflab6)
	SERVERSLIST="pcrflab6"	
	LAB=1
;;
pcrflab9)
	SERVERSLIST="pcrflab9"	
	LAB=1
;;
rjmck02ium2)
	SERVERSLIST="rjmck02ium1 rjmck02ium2 rjmck02ium4"
;;
spcas04ium2|spame02ium2)
	for (( NUM=2; NUM<=${NUM_IUM_INST}; NUM++ ))
	do
		SERVERSLIST="$SERVERSLIST ${SITE_AUX}${NUM}"
	done
;;
* )
	for (( NUM=1; NUM<=${NUM_IUM_INST}; NUM++ ))
	do
		SERVERSLIST="$SERVERSLIST ${SITE_AUX}${NUM}"
	done
esac

for SERVER in ${SERVERSLIST}
do
  BOTAFOGO=`echo ${SERVER} |cut -c 1-5`
  if [ "${TRICK}${BOTAFOGO}" = "Xrjium" ]
     then
        IUMNUMBER=`echo ${SERVER} |cut -c 3-6`
     else   
        SERVER_LEN="${#SERVER}" 
        IUMNUMBER=`echo ${SERVER} |cut -c 8-${SERVER_LEN}`
  fi      
  if [ "${TRICK}${IUMNUMBER}" = "Xium1" ]
     then
       for SS in NotHLR_01P NotCDR_01P CCNCDR_01P SB_DRs_01P SP_DRs_01P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium2" ]
     then
       for SS in NotHLR_01B NotCDR_01B CCNCDR_01B SB_DRs_01B SP_DRs_01B
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium3" ]
     then
       for SS in PCC_Gy_CDRS_01P CCNCDR_BE_01P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium4" ]
     then
       for SS in PCC_Gy_CDRS_02P CCNCDR_BE_02P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium5" ]
     then
       for SS in PCC_Gy_CDRS_03P CCNCDR_BE_03P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium6" ]
     then
       for SS in PCC_Gy_CDRS_04P CCNCDR_BE_04P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium7" ]
     then
       for SS in PCC_Gy_CDRS_05P CCNCDR_BE_05P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium8" ]
     then
       for SS in PCC_Gy_CDRS_06P CCNCDR_BE_06P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium9" ]
     then
       for SS in PCC_Gy_CDRS_07P CCNCDR_BE_07P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium10" ]
     then
       for SS in PCC_Gy_CDRS_08P CCNCDR_BE_08P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  if [ "${LAB}" -gt 0 ]
     then
       for SS in PCC_Gy_CDRS_06P CCNCDR_BE_01P
        do
          echo `siucontrol -n ${SS} -host ${SERVER} -c startProc` &
        done  
  fi
  
done


