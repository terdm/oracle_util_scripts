DECLARE
  F_LOAD_DATE  DATE;   
  F_BIND   RISK_CORE.CORE_PARAM_TAB;
  IN_SUBST RISK_CORE.CORE_PARAM_TAB;
  P_MSG  CLOB;
  P_RECIPIENTS VARCHAR2(255);
  P_SCENARIO varchar2(30) := 'CHECK_LOG';  
BEGIN

  P_RECIPIENTS := 'mail@mail.ru';
  RISK_CORE.CORE_LOG_PKG.SET_TIMER_P('ON');
  F_LOAD_DATE := TO_DATE('11.08.2021', 'DD.MM.YYYY');-- '16.02.2019'
  F_BIND := RISK_CORE.CORE_PARAM_TAB();
  
  RISK_CORE.CORE_EXPRESSION_PKG.SET_PARAM_P(F_BIND, 'SLOT_ID', 4); -- !!!
  RISK_CORE.CORE_EXPRESSION_PKG.SET_PARAM_P(F_BIND, 'F_LOAD_DATE', F_LOAD_DATE);
  
  RISK_CORE.CORE_EXPRESSION_PKG.RUN_STATEMENT_BIND(IN_SCENARIO => P_SCENARIO, 
                                                       IN_BIND => F_BIND, 
                                                      IN_SUBST => null, 
                                                    OUT_REPORT => P_MSG, 
                                           IN_IGNORE_ERROR_FLG => 'N' , 
                                                     IN_RUN_ID => '');  
  RISK_CORE.CORE_UTIL_PKG.SEND_MAIL_P
    (IN_TO => P_RECIPIENTS,  
      IN_TITLE => RISK_CORE.CORE_LOG_PKG.MODULE || ' за ' || TO_CHAR(F_LOAD_DATE, 'dd.mm.yyyy'),
      IN_BODY_MSG => P_MSG, 
      IN_PRIORITY => '1' 
    );  
                           
    RISK_CORE.CORE_LOG_PKG.SET_TIMER_P('OFF');
    dbms_output.put_line(RISK_CORE.CORE_LOG_PKG.MODULE || ' за ' || TO_CHAR(F_LOAD_DATE, 'dd.mm.yyyy'));
END;
