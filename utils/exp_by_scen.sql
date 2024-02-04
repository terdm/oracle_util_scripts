with t0 as (  
  SELECT scen_id,
         scen_seq scsq,
         scen_active_flg scaf,
         scen_scenario,
         scen_exp_id,
         exp_expression,
         exp_version
             ev,
         exp$osuser,
         exp$change_date,    
         SUBSTR (exp_desc, 1, 120)
             exd,
         (SELECT LISTAGG (cp_proc_name || '-' || cp_act_flag,',')
                     WITHIN GROUP (ORDER BY 1)
            FROM core_process
           WHERE cp_scen_name = scen_scenario) pl, 
          (SELECT LISTAGG (cp_proc_name || '-' || cp_act_flag||'-<'||
                         (select listagg (CPCS_NAME||' '||CPCS_IS_REGULAR||' '||to_char(24*cpcs_time),'+') within group (order by 1) from core_prc_chain_sched where CPCS_IS_REGULAR = 'y' AND cpc_id in (select cpcn.cpc_id from core_prc_chain_nodes cpcn where cpa_id in (select cpa_id from core_process_atr where cpa_proc_name = cp_proc_name)))
                          ||'>',',')
                     WITHIN GROUP (ORDER BY 1)
            FROM core_process
           WHERE cp_scen_name = scen_scenario) CHl,
             exp_return_bind_used,EXP_SUBST_USED,EXP_BIND_USED,
             scen_subst_value,
             row_number( ) over (partition by exp_id,scen_scenario,scen_subst_value order by exp_version desc) rn
    FROM core_scenario cs, core_expression
   WHERE 1=1 --scen_scenario = 'LOAD_KRM_REF_EVRYD#10' 
    and regexp_like(exp_expression , 'S24_PHYS_PERSON','i')
     
    --exp_id  = 'FIND_MAX_DATE'
   AND scen_exp_id = exp_id)
   select * 
   from t0 
   where rn =1
   --and pl like '%BANKLED%'
ORDER BY scen_scenario, scsq, ev;
--164

