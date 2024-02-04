with

t00 as (select 15 q from dual)

,t0 as (select 100 nm ,  q from t00 union all select 200 nm , q from t00  union all select 500 nm ,  q from t00 )

,t1 as (select nm,q,level ll from t0 connect by level < q+1 and prior nm = nm and prior sys_guid() is not null

)

,t2 (s,c,cnt,seq) as

(

select 0 s, ' ' c, 0 cnt,' ' from dual

union all

select s + nm, c||substr(nm,1,1), length(c) - length(replace(c,substr(nm,1,1),'')) ,

seq||';'||substr(nm,1,1)||'-'||ll

 

from t2 t21 , t1

where s+nm <=1000

and 1+ length(c) - length(replace(c,substr(nm,1,1),'')) <= q

and instr(seq||';',';'||substr(nm,1,1)||'-'||ll||';') = 0

and substr(c,-1,1)<=substr(nm,1,1)

and (instr(seq||';',';'||substr(nm,1,1)||'-'||to_char(ll-1)||';') <> 0 or ll = 1)

--and not exists (select 1 from t2 t22 where t21.c = replace(t22.c,substr(nm,1,1),''))

--and not exists (select 1 from t2)

)

select * from t2 where s = 1000;

 