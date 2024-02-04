declare
n            number := 12;
vCpc_id      number := 1037;
vCpa_id      number := 1355;
i            number := 1;
vNewCpcn_id  number;
vOldCpcn_id  number;
vStartDate   date := to_date('01.01.2020','DD.MM.RRRR');
vAddMonths   number := 3;
begin
    -- удаляем старые вектора
    delete from core_prc_chain_vecs where cpc_id =  vCpc_id;
    dbms_output.put_line(' core_prc_chain_vecs rows deleted  '||Sql%RowCount);
    -- удаляем параметры нод
    delete from CORE_PRC_CHAIN_NODES_PARAMS where CPCN_ID  in (select cpcn_id from core_prc_chain_nodes where cpc_id = vCpc_id);
    dbms_output.put_line(' CORE_PRC_CHAIN_NODES_PARAMS rows deleted  '||Sql%RowCount);
    -- удаляем ноды
    delete from core_prc_chain_nodes where cpc_id = vCpc_id;
    dbms_output.put_line(' core_prc_chain_nodes rows deleted  '||Sql%RowCount);
    
    -- в цикле создаём ноду цепочки
    while i <= n loop 
        
        Insert into RISK_CORE.CORE_PRC_CHAIN_NODES
           ( CPC_ID, CPA_ID, CPCN_NAME, CPCN_DESC, 
            CPCN_FOR_PERIOD)
         Values
           ( vCpc_id, vCpa_id, 'Загрузка SBHRM '||i, 'Загрузка SBHRM '||i, 
            'N') returning cpcn_id into vNewCpcn_id ;
        -- устанавливаем её связь с предыдущей нодой
        if vOldCpcn_id is not null then
           Insert into RISK_CORE.CORE_PRC_CHAIN_VECS
           ( CPC_ID, CPCN_ID_FROM, CPCN_ID_TO, IS_POS_RES)
         Values
           ( vCpc_id, vOldCpcn_id, vNewCpcn_id, 'Y');
            
        end if;
        vOldCpcn_id := vNewCpcn_id;
        -- указываем параметры 

        Insert into RISK_CORE.CORE_PRC_CHAIN_NODES_PARAMS
           ( CPCN_ID, CPCNP_PARAM_NAME, CPCNP_PARAM_DATA, CPCNP_PARAM_IS_EXPR)
         Values
           ( vNewCpcn_id, 'F_START_DATE', to_char(add_months(vStartDate, vAddMonths * (i - 1)), 'DD.MM.RRRR'), 'N');
        Insert into RISK_CORE.CORE_PRC_CHAIN_NODES_PARAMS
           ( CPCN_ID, CPCNP_PARAM_NAME, CPCNP_PARAM_DATA, CPCNP_PARAM_IS_EXPR)
         Values
           ( vNewCpcn_id, 'F_END_DATE', to_char(add_months(vStartDate, vAddMonths * i ) - 1, 'DD.MM.RRRR'), 'N');

        i := i + 1;
    end loop;
   
end;
