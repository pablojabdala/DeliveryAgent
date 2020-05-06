#!/bin/sh

WORKDIR="/home/iumadmin/tmp"
test -d $WORKDIR || mkdir -p $WORKDIR
DATESTR=`date +"%Y%m%d%H%M%S"`
DEPLOYDIR=${WORKDIR}/Deploy
DEPLOYDIROLD=${DEPLOYDIR}.${DATESTR}
test -d $DEPLOYDIR && mv $DEPLOYDIR $DEPLOYDIROLD

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
rjmck02brms1)
        SERVERSLIST="rjmck02brms1"
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

cd $WORKDIR
tar -xvf Deploy.tar.gz
chmod -R 755 Deploy
for SERVER in ${SERVERSLIST}
do
  DEPLOYDIR=${WORKDIR}/Deploy/${SERVER}
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
          CFGGROUP=`echo ${SS} |cut -c 1-3`
          if [ "${TRICK}${CFGGROUP}" = "XNot" ]
            then
              loadconfig -f ${DEPLOYDIR}/CFG_NOTIF/${SS}.cfg
            else
               CFGGROUP=`echo ${SS} |cut -c 1-3`
               if [ "${TRICK}${CFGGROUP}" = "XPCC" ]
                 then
                    loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
                 else   
                    CFGGROUP=`echo ${SS} |cut -c 1-3`
                    if [ "${TRICK}${CFGGROUP}" = "XCCN" ]
                      then
                         loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/${SS}.cfg
                      else
                         loadconfig -f ${DEPLOYDIR}/CFG_SUBS/${SS}.cfg
                    fi     
              fi
          fi
        done  
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium2" ]
     then
		if [ "${TRICK}${HOSTSERVER}" != "Xspame02ium2" ] && [ "${TRICK}${HOSTSERVER}" != "Xspcas04ium2" ]; then
		   for SS in NotHLR_01P NotCDR_01B CCNCDR_01B SB_DRs_01B SP_DRs_01B
			do
			  CFGGROUP=`echo ${SS} |cut -c 1-3`
			  if [ "${TRICK}${CFGGROUP}" = "XNot" ]
				then
				  loadconfig -f ${DEPLOYDIR}/CFG_NOTIF/${SS}.cfg
				else
				   CFGGROUP=`echo ${SS} |cut -c 1-3`
				   if [ "${TRICK}${CFGGROUP}" = "XPCC" ]
					 then
						loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
					 else   
						CFGGROUP=`echo ${SS} |cut -c 1-3`
						if [ "${TRICK}${CFGGROUP}" = "XCCN" ]
						  then
							 loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/${SS}.cfg
						  else
							 loadconfig -f ${DEPLOYDIR}/CFG_SUBS/${SS}.cfg
						fi     
				  fi
			  fi
			done
		fi
      
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium3" ]
     then
       for SS in PCC_Gy_CDRS_01P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_01P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium4" ]
     then
       for SS in PCC_Gy_CDRS_02P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_02P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium5" ]
     then
       for SS in PCC_Gy_CDRS_03P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_03P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium6" ]
     then
       for SS in PCC_Gy_CDRS_04P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_04P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium7" ]
     then
       for SS in PCC_Gy_CDRS_05P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_05P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium8" ]
     then
       for SS in PCC_Gy_CDRS_06P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_06P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium9" ]
     then
       for SS in PCC_Gy_CDRS_07P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_07P.cfg
  fi
  if [ "${TRICK}${IUMNUMBER}" = "Xium10" ]
     then
       for SS in PCC_Gy_CDRS_08P
        do
          loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
        done  
       loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/CCNCDR_BE_08P.cfg
  fi

  if [ "${LAB}" -gt 0 ]
     then
       for SS in NotificationA_01P NotHLR_01P NotCDR_01P NotMail_01P CCNCDR_01P CCNCDR_BE_01P PCC_Gx_ST_FE_01P PCC_Gy_ST_FE_01P SB_DRs_01P Subscription_01P SubscriptionTasks_01P SP_DRs_01P WS_Subscriber_01P PCC_Gx_ST_BE_01P PCC_Gx_ST_BE_02P PCC_Gy_CDRS_01P PCC_Gy_ST_BE_01P PCC_Gy_ST_BE_02P PCC_Gx_LTE_FE_01P PCC_Gx_LTE_BE_01P PCC_Gx_LTE_BE_02P PCC_Gy_LTE_FE_01P PCC_Gy_LTE_BE_01P PCC_Gy_LTE_BE_02P PCC_Gx_WF_FE_01P PCC_Gy_WF_FE_01P PCC_Gx_WF_BE_01P PCC_Gx_WF_BE_02P PCC_Gy_WF_BE_01P PCC_Gy_WF_BE_02P PCC_Gy_ZTE_FE_01P PCC_POL_CDRS_01P PCC_REP_CDRS_01P
        do
          CFGGROUP=`echo ${SS} |cut -c 1-3`
          if [ "${TRICK}${CFGGROUP}" = "XNot" ]
            then
              loadconfig -f ${DEPLOYDIR}/CFG_NOTIF/${SS}.cfg
            else
               CFGGROUP=`echo ${SS} |cut -c 1-3`
               if [ "${TRICK}${CFGGROUP}" = "XPCC" ]
                 then
                    loadconfig -f ${DEPLOYDIR}/CFG_PCC/${SS}.cfg
                 else   
                    CFGGROUP=`echo ${SS} |cut -c 1-3`
                    if [ "${TRICK}${CFGGROUP}" = "XCCN" ]
                      then
                         loadconfig -f ${DEPLOYDIR}/CFG_OTHERS/${SS}.cfg
                      else
                         loadconfig -f ${DEPLOYDIR}/CFG_SUBS/${SS}.cfg
                    fi     
              fi
          fi
        done  
       for SS in SNMESchema NMESchema
        do
          loadconfig -f ${DEPLOYDIR}/CFG_NME_SCHEMA/${SS}.cfg
        done        
  fi
done



