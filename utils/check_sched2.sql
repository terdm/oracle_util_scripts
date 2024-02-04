WITH
    T0
    AS
        (SELECT TO_DATE ('08.02.2022 10:00', 'DD.MM.RRRR HH24:Mi')  TESTED_DATE_START, -- предполагаемое время начала
                TO_DATE ('08.02.2022 17:00', 'DD.MM.RRRR HH24:Mi')  TESTED_DATE_END, -- предполагаемое время начала
                --50 / 24  DELTA, -- предполагаемая длительность
                'BANKLED_STAGE#10' TESTED_PROC -- процесс к запуску 
                --'BALANCE_HISTORY' TESTED_PROC -- процесс к запуску 
           FROM DUAL)
    ,tDays  as (select trunc(TESTED_DATE_START) + level - 1   tTruncTestDate ,level lvl from t0 connect by level <= (trunc(TESTED_DATE_END)-trunc(TESTED_DATE_START)+1))     
    --select * from tDays; 
     
    ,PROC_SCEN
    AS
        (SELECT CP_SCEN_NAME
           FROM T0, CORE_PROCESS
          WHERE CP_PROC_NAME = TESTED_PROC),
    SCHED_SCEN
    AS
        (SELECT CP_SCEN_NAME,
                CPCN_NAME,
                decode(CPCS_IS_REGULAR,'Y',tTruncTestDate + CPCS_TIME,CPCS_DATE)     SCHED_TIME
           FROM T0,
                tDays,
                CORE_PRC_CHAIN_SCHED  SCHED,
                CORE_PRC_CHAIN_NODES  N,
                CORE_PROCESS_ATR      CPA,
                CORE_PROCESS          CP
          WHERE        SCHED.CPC_ID = N.CPC_ID
                   AND CPA.CPA_ID = N.CPA_ID
                   AND CP.CP_PROC_NAME = CPA.CPA_PROC_NAME
                   AND ((    CPCS_IS_REGULAR = 'Y'
                             AND (TRUNC (tTruncTestDate) + CPCS_TIME) BETWEEN T0.TESTED_DATE_START
                                                                                AND   T0.TESTED_DATE_END
                                                                                    
                             AND DECODE (
                                     TO_CHAR (tTruncTestDate,
                                              'D',
                                              'nls_date_language=RUSSIAN'),
                                     1, CPCS_1,
                                     2, CPCS_2,
                                     3, CPCS_3,
                                     4, CPCS_4,
                                     5, CPCS_5,
                                     6, CPCS_6,
                                     7, CPCS_7) =
                                 'Y')
                        OR (    CPCS_IS_REGULAR = 'N' and lvl=1
                            AND CPCS_DATE BETWEEN T0.TESTED_DATE_START
                                              AND T0.TESTED_DATE_END))
                   )
--select * from SCHED_SCEN;                                      
  SELECT CPCN_NAME,
         TO_CHAR (SCHED_TIME, 'DD.MM.RRRR HH24:Mi')                  START_TIME,
         LISTAGG (S.CP_SCEN_NAME, ',') WITHIN GROUP (ORDER BY 1)     SCEN_LIST
    FROM PROC_SCEN P, SCHED_SCEN S
   WHERE P.CP_SCEN_NAME = S.CP_SCEN_NAME AND P.CP_SCEN_NAME <> 'CHECK_LOG'
GROUP BY CPCN_NAME, SCHED_TIME