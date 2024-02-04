-- запуск процесса – предварительно инициировать параметры процесса в таблице CORE_PROCESS_PARAM
DECLARE 
  IN_PROC_NAME VARCHAR2(32767);
  IN_RUN_TYPE VARCHAR2(32767);
  IN_RUN_ID VARCHAR2(32767);
  vCPA_PROC_RECIP  varchar2(1000);
BEGIN 
  IN_PROC_NAME := 'TEST_FLD_1';
  --IN_PROC_NAME := 'GROUP_RS_RUNID';
  IN_RUN_TYPE := NULL;
  IN_RUN_ID := -555; -- при запуске из APEX подставляется автоматически
  --select CPA_PROC_RECIP  into vCPA_PROC_RECIP  from core_process_atr where cpa_proc_name = IN_PROC_NAME;
  --vCPA_PROC_RECIP := 'DAILY';

  RISK_CORE.CORE_PROCESS_PKG.START_PROCESS_P ( IN_PROC_NAME, IN_RUN_TYPE, IN_RUN_ID );   
  --update core_process_atr set  CPA_PROC_RECIP = vCPA_PROC_RECIP where cpa_proc_name = IN_PROC_NAME;
  dbms_output.put_line('vCPA_PROC_RECIP '||vCPA_PROC_RECIP);
  
  commit;
  exception when others then
  if vCPA_PROC_RECIP is not null then
    update core_process_atr set  CPA_PROC_RECIP = vCPA_PROC_RECIP where cpa_proc_name = IN_PROC_NAME;
    commit;
  end if;
END;

select * from core_log order by 1 desc ;
 
