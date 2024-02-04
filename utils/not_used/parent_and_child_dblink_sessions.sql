select /*+ ordered */ substr(s.ksusemnm,1,35)||'-'|| substr(s.ksusepid,1,35) origin,
substr(g.k2gtitid_ora,1,50) gtxid,
substr(s.indx,1,4)||'.'|| substr(s.ksuseser,1,5) lsession,
s.ksuudlna username,
substr(decode(bitand(ksuseidl,11), 1,'ACTIVE', 0, decode( bitand(ksuseflg,4096) , 0,'INACTIVE','CACHED'), 2,'SNIPED', 3,'SNIPED', 'KILLED'),1,1) status,
e.kslednam waiting
from x$k2gte g, x$ktcxb t, x$ksuse s, x$ksled e
where g.k2gtdxcb=t.ktcxbxba
and g.k2gtdses=t.ktcxbses
and s.addr=g.k2gtdses
and e.indx=s.ksuseopc;
