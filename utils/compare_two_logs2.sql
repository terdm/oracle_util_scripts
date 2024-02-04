/* Formatted on 17.01.2022 12:52:19 (QP5 v5.326) */
  SELECT *
    FROM core_log where log_exp_id = 'CHECK_LOG'
    and log_run_id in (select CPL_RUN_ID from core_process_log where cpl_proc_name = 'STREAM_MARKET')
ORDER BY 1 DESC;

  SELECT *
    FROM core_log@DBLINK_EVMPRE where log_exp_id = 'CHECK_LOG'
    and log_run_id in (select CPL_RUN_ID from core_process_log@DBLINK_EVMPRE where cpl_proc_name = 'STREAM_MARKET')
ORDER BY 1 DESC;

SELECT *
  FROM core_log
 WHERE log_id = 3589712;

  SELECT *
    FROM core_log@dblink_evmpre
   WHERE log_exp_id = 'CHECK_LOG' AND log_id = 3675679
ORDER BY 1 DESC;

with t0 as(
SELECT z.*,'PROD' base
  FROM core_log,
       XMLTABLE ('ROOT/ROWSET/ROW'
                 PASSING XMLTYPE (LOG_EXP_REPORT)
                 COLUMNS MESSAGE VARCHAR2 (2000) PATH 'MESSAGE',
                         PROCESSED_ROW VARCHAR2 (2000) PATH 'PROCESSED_ROW') z
 WHERE log_id = 3589712 union
 
 
 SELECT z.*,'PRE'
  FROM core_log@dblink_evmpre,
       XMLTABLE ('ROOT/ROWSET/ROW'
                 PASSING XMLTYPE (LOG_EXP_REPORT)
                 COLUMNS MESSAGE VARCHAR2 (2000) PATH 'MESSAGE',
                         PROCESSED_ROW VARCHAR2 (2000) PATH 'PROCESSED_ROW') z
 WHERE log_id = 3675868 )
 select * from t0 t00
 where not exists (select 1 from t0 where t00.MESSAGE = t0.message and t00.processed_row = t0.processed_row and t00.base <>t0.base)
 order by 1;