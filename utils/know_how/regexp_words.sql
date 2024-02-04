WITH

t0 as (SELECT exp_expression text from core_expression where exp_id = 'LOAD_DISCOUNT_FACTOR' and exp_version = 4),

recursive_cte (text, start_pos, end_pos) AS (

  SELECT  text, 1 AS start_pos, regexp_instr(text, '\w+',1,1,1,'mn') AS end_pos

  FROM t0

  UNION ALL

  SELECT text, end_pos+1 start_pos, regexp_INSTR(text, '\w+', end_pos ,1,1,'mn') end_pos

  FROM recursive_cte

  WHERE end_pos > 0

)

,t1 as (

SELECT

to_char(regexp_SUBSTR(text, '\w+' ,start_pos)) wword,

start_pos,end_pos

FROM recursive_cte)

select distinct owner,object_name,object_type from t1,all_objects where object_name = wword and object_type not in ('TABLE PARTITION')

;