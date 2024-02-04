WITH
    T0
    AS
        (SELECT TO_DATE ('16.08.2021 12:07', 'DD.MM.RRRR HH24:Mi')  TESTED_DATE_START, -- предполагаемое время начала
                1 / 24  DELTA, -- предполагаемая длительность
                --'BANKLED_STAGE' TESTED_PROC -- процесс к запуску 
                'BANKLED_MAIN#10' TESTED_PROC -- процесс к запуску 
           FROM DUAL),
    PROC_SCEN
    AS
        (SELECT CP_SCEN_NAME
           FROM T0, CORE_PROCESS
          WHERE CP_PROC_NAME = TESTED_PROC),
    SCHED_SCEN
    AS
        (SELECT CP_SCEN_NAME,
                CPCN_NAME,
                TRUNC (T0.TESTED_DATE_START) + CPCS_TIME     SCHED_TIME
           FROM T0,
                CORE_PRC_CHAIN_SCHED  SCHED,
                CORE_PRC_CHAIN_NODES  N,
                CORE_PROCESS_ATR      CPA,
                CORE_PROCESS          CP
          WHERE        SCHED.CPC_ID = N.CPC_ID
                   AND CPA.CPA_ID = N.CPA_ID
                   AND CP.CP_PROC_NAME = CPA.CPA_PROC_NAME
                   AND ((    CPCS_IS_REGULAR = 'Y'
                         AND (TRUNC (T0.TESTED_DATE_START) + CPCS_TIME) BETWEEN T0.TESTED_DATE_START
                                                                            AND   T0.TESTED_DATE_START
                                                                                + T0.DELTA
                         AND DECODE (
                                 TO_CHAR (T0.TESTED_DATE_START,
                                          'D',
                                          'nls_date_language=RUSSIAN'),
                                 1, CPCS_1,
                                 2, CPCS_2,
                                 3, CPCS_3,
                                 4, CPCS_4,
                                 5, CPCS_5,
                                 6, CPCS_6,
                                 7, CPCS_7) =
                             'Y'))
                OR (    CPCS_IS_REGULAR = 'N'
                    AND CPCS_DATE BETWEEN T0.TESTED_DATE_START
                                      AND T0.TESTED_DATE_START + T0.DELTA))
  SELECT CPCN_NAME,
         TO_CHAR (SCHED_TIME, 'DD.MM.RRRR HH24:Mi')                  START_TIME,
         LISTAGG (S.CP_SCEN_NAME, ',') WITHIN GROUP (ORDER BY 1)     SCEN_LIST
    FROM PROC_SCEN P, SCHED_SCEN S
   WHERE P.CP_SCEN_NAME = S.CP_SCEN_NAME AND P.CP_SCEN_NAME <> 'CHECK_LOG'
GROUP BY CPCN_NAME, SCHED_TIME