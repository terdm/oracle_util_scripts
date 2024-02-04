DECLARE
  F_LOAD_DATE  DATE;   
  F_BIND   RISK_CORE.CORE_PARAM_TAB;
  IN_SUBST RISK_CORE.CORE_PARAM_TAB;
  P_MSG  CLOB;
  P_RECIPIENTS VARCHAR2(255);
  P_SCENARIO varchar2(30) := 'TEST_SLCMI';  
BEGIN

  P_RECIPIENTS := 'mail@mail.ru';
  RISK_CORE.CORE_LOG_PKG.SET_TIMER_P('ON');
  F_LOAD_DATE := TO_DATE('22.07.2021', 'DD.MM.YYYY');-- '16.02.2019'
  F_BIND := RISK_CORE.CORE_PARAM_TAB();
  
  --RISK_CORE.CORE_EXPRESSION_PKG.SET_PARAM_P(F_BIND, 'SLOT_ID', 10); -- !!!
  RISK_CORE.CORE_EXPRESSION_PKG.SET_PARAM_P(F_BIND, 'F_LOAD_DATE', F_LOAD_DATE);
  RISK_CORE.CORE_EXPRESSION_PKG.RUN_STATEMENT_BIND(P_SCENARIO, F_BIND, F_BIND, P_MSG,'N');  
  RISK_CORE.CORE_UTIL_PKG.SEND_MAIL_P
    (IN_TO => P_RECIPIENTS,  
      IN_TITLE => RISK_CORE.CORE_LOG_PKG.MODULE || ' за ' || TO_CHAR(F_LOAD_DATE, 'dd.mm.yyyy'),
      IN_BODY_MSG => P_MSG, 
      IN_PRIORITY => '1' 
    );  
                           
    RISK_CORE.CORE_LOG_PKG.SET_TIMER_P('OFF');
    dbms_output.put_line(RISK_CORE.CORE_LOG_PKG.MODULE || ' за ' || TO_CHAR(F_LOAD_DATE, 'dd.mm.yyyy'));
END;


DECLARE
  F_BIND   RISK_CORE.CORE_PARAM_TAB;
  P_MSG  CLOB;
BEGIN
  RISK_CORE.CORE_LOG_PKG.SET_TIMER_P('ON');
  F_BIND := RISK_CORE.CORE_PARAM_TAB();    
  RISK_CORE.CORE_EXPRESSION_PKG.RUN_STATEMENT_BIND('TEST_SLCMI', F_BIND, null, P_MSG,'Y');  
  RISK_CORE.CORE_LOG_PKG.SET_TIMER_P('OFF');
END;

delete from UDAV_TEST_RETURN_BIND;
edit UDAV_TEST_RETURN_BIND;
alter table UDAV_TEST_RETURN_BIND add (ddate date default sysdate);
select * from UDAV_TEST_RETURN_BIND;
insert into UDAV_TEST_RETURN_BIND select * from UDAV_TEST_RETURN_BIND;
select * from all_objects where object_name ='UDAV_TEST_RETURN_BIND';

create table UDAV_TEST_RETURN_BIND(dt varchar2(100));

select * from core_expression where exp_id in (select scen_exp_id from core_scenario where scen_scenario = 'TEST_RETURN_BIND');

edit core_expression where exp_id in (select scen_exp_id from core_scenario where scen_scenario = 'TEST_RETURN_BIND') order by exp_desc;
SELECt * from core_log where log_run_id = (select max(log_run_id) keep (dense_rank first order by log_id desc) from core_log ) order by 1; 
