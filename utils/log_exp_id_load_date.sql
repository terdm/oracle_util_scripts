with t0 as (
select clg.*,
to_date(regexp_substr(log_desc,'\d\d\.\d\d\.\d\d\d\d'),'DD.MM.RRRR')  load_date 
from core_log clg where log_exp_id = 'DEAL_DEPOSIT_NSO')
select load_date,log_date,log_processed_row from t0 order by load_date desc, log_date desc;