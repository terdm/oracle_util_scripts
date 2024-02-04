Find session who generating lot of undo in Oracle
Find the session using more undo tablespace

select a.sid, a.serial#, a.username, b.used_urec used_undo_record, b.used_ublk used_undo_blocks
from v$session a, v$transaction b
where a.saddr=b.ses_addr ;

Note:
used_ublk column means how many UNDO blocks are currently used by DML operation.
used_urec column means the number of UNDO rows that are being stored by DML operation.
Check the SQL TEXT using or generating undo segments

select s.sql_text from v$sql s, v$undostat u where u.maxqueryid=s.sql_id;
OR
select sql.sql_text, t.used_urec records, t.used_ublk blocks,
(t.used_ublk*8192/1024) kb from v$transaction t,
v$session s, v$sql sql
where t.addr=s.taddr
and s.sql_id = sql.sql_id;

select * from v$undostat;
Check the undo usage by session

select
s.sid,s.serial#,
NVL(s.username, 'NA') orauser,
s.program,r.name undoseg,
t.used_ublk * TO_NUMBER(x.value)/1024||'K' "Undo"
from
sys.v_$rollname r,
sys.v_$session s,
sys.v_$transaction t,
sys.v_$parameter x
where s.taddr = t.addr
AND r.usn = t.xidusn(+)
AND x.name = 'db_block_size';
