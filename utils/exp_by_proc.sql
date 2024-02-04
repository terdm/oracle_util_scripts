SELECT 
             cp.cp_scen_seq,
             CP_ACT_FLAG,
             cs.scen_id,
             cs.scen_scenario,
             cs.SCEN_ACTIVE_FLG,
             cs.SCEN_SEQ,
             cs.SCEN_BIND_VALUE,
             exp_id,
             --instr(exp_expression,'NOLOAD') ino,
             EXP_VERSION,
             EXP_EXPRESSION,
             EXP_XLST,
             EXP_BIND_USED,
             EXP_SUBST_USED,
             cs.scen_subst_value,
             EXP_RETURN_BIND_USED,
             EXP_DESC,
             EXP_COMMIT,
             (select LISTAGG(CPP_PARAM_NAME||'='||cpp_param_data, ', ') within group (order by CPP_PARAM_NAME) from risk_core.core_PROCESS_PARAM where CPP_PROC_NAME = cp.cp_proc_name) params,
             pos,
             EXP$OSUSER,
             FN_GET_USERNAME_BY_LOGIN(EXP$OSUSER) EXP_USERNAME,
             exp$change_date,
             FN_GET_USERNAME_BY_LOGIN(SCEN$OSUSER) SCEN_USERNAME
        from risk_core.core_process cp,
             risk_core.core_scenario cs,             
             (SELECT exp_id,
                     EXP_TYPE,
                     EXP_VERSION,
                     EXP_EXPRESSION,
                     EXP_XLST,
                     EXP_BIND_USED,
                     EXP_SUBST_USED,
                     EXP_RETURN_BIND_USED,
                     EXP_DESC,
                     EXP_COMMIT,
                     EXP$osuser,
                     exp$change_date,
                     ROW_NUMBER ()
                         OVER (PARTITION BY EXP_ID
                               ORDER BY EXP_VERSION DESC, EXP$CHANGE_DATE DESC)
                         POS
                from risk_core.core_expression) ex
       WHERE     cp_proc_name = :PROC_NAME
             AND cp.cp_scen_name = cs.scen_scenario
             AND ex.exp_id = cs.scen_exp_id
             AND pos = 1
             and scen_active_flg = 'Y'  
             and cp_act_flag = 'Y' 
             --and instr(exp_xlst,'Статистика по атрибутам (пассивы) перед загрузкой в PORT')  <>0 
             --and instr(exp_expression,'DDEP_CLNT_REFERENCE')  <>0     
             --and regexp_instr(exp_expression,'scred_client_description',1,1,1,'i')<>0
             --and instr(exp_expression,'LCM_SOURCE_CODE')  <>0
             --and exp_expression like '%S01_NSO%'
             
             --and regexp_like(exp_expression , 'Volatility','i')
             --and regexp_like(exp_expression , 'SRC_RNM','i')
             --and scen_scenario = 'LOAD_MAIN_CLIENT'
                       
    ORDER BY 
    cp_scen_seq, SCEN_SEQ ;