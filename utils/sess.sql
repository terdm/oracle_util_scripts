select count(*) cc,Sql_exec_start, status,sysdate - last_call_et/24/3600,
listagg(program,chr(13)) within group (order by 1) pss,
listagg(sql_id,chr(13)) within group (order by 1) sqls
from v$session  where regexp_like(program,'\(P...\)') 
group by sql_exec_start,status,last_call_et; 

select * from v$sql where sql_id = '7fd8trs84jq9rd';

select count(s.status) inactive_sessions
from v$session s,v$process p
where p.addr=s.paddr and
s.status = 'INACTIVE' and
s.LAST_CALL_ET > 36000;

select *
from v$session s,v$process p
where p.addr=s.paddr 
--and s.status = 'INACTIVE' 
and
s.LAST_CALL_ET > 36000;

select round(LAST_CALL_ET/3600/24) Days,
nvl((SELECT 
   DPR_NAME
FROM RISK_CORE.DICT_RECIP_PERSONS where upper(DPR_DOMEN_NAME) = upper(s.OSUSER)),s.username) username,
s.sid, s.serial#,machine,s.program,
s.status,
AUDSID,PADDR,USER#,OWNERID,SERVER,SCHEMA#,SCHEMANAME,OSUSER,PROCESS,PORT,P.TERMINAL,TYPE,PREV_EXEC_START,PREV_EXEC_ID,MODULE,ACTION,
LOGON_TIME,LAST_CALL_ET,BLOCKING_SESSION_STATUS,SEQ#,STATE,SPID,
--s.*,p.*,
--, 'ALTER SYSTEM KILL SESSION '''||SID||','||s.SERIAL#||''' IMMEDIATE;'
'exec SYS.KILL_SESSION('||SID||','||s.SERIAL#||');' Oracle_kill_command,
'kill -9 '||p.spid linux_kill_command
from v$session s , v$process p
where p.addr=s.paddr
and
s.LAST_CALL_ET > 3600*24*1 and
s.status in ('INACTIVE','KILLED')
--group by s.program
order by 1 desc;

--exec SYS.KILL_SESSION(#sid,#serial);
alter system disconnect session '550,8981'immediate;

select * from all_tablespaces;



select count(s.status) inactive_sessions
from v$session s,v$process p
where p.addr=s.paddr and
s.status = 'INACTIVE' and
s.LAST_CALL_ET > 36000;

select *
from v$session s , v$process p
where p.addr=s.paddr
and
s.LAST_CALL_ET > 3600*24*1 and
s.status = 'INACTIVE'
--group by s.program
order by 2 desc;

select * from v$px_process;
select * from v$px_session;

select program,
(select value
from v$sesstat
where v$sesstat.sid = v$session.sid
and statistic# = (select statistic#
from v$statname
where name = 'consistent gets' ) ) cgs,
(select value
from v$sesstat
where v$sesstat.sid = v$session.sid
and statistic# = (select statistic#
from v$statname
where name = 'CPU used by this session' ) ) cpu
,v$session.*
from v$session
where status = 'ACTIVE'  and type = 'USER'
order by 2 desc;

select program,
(select value
from v$sesstat
where v$sesstat.sid = v$session.sid
and statistic# = (select statistic#
from v$statname
where name = 'consistent gets' ) ) cgs,
(select value
from v$sesstat
where v$sesstat.sid = v$session.sid
and statistic# = (select statistic#
from v$statname
where name = 'CPU used by this session' ) ) cpu
,v$session.*

from v$session 

where username = 'KRM_DBA' 
order by 2 desc