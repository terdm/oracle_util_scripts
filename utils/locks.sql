SELECT bs.username
           Blocking_User,
         ws.username
           Waiting_User,
         bs.sid
           sid,
         bs.audsid
           audsid,
         ws.sid
           wsid,
         bs.serial#
           Serial#,
         (CASE
            WHEN bs.sql_hash_value = 0 THEN bs.prev_hash_value
            ELSE bs.sql_hash_value
          END)
           Blocking_Sql_hash,
         (CASE
            WHEN bs.sql_hash_value = 0 THEN bs.prev_sql_addr
            ELSE bs.sql_address
          END)
           Blocking_sql_address,
         (CASE
            WHEN ws.sql_hash_value = 0 THEN ws.prev_hash_value
            ELSE ws.sql_hash_value
          END)
           Waiting_Sql_hash,
         (CASE
            WHEN ws.sql_hash_value = 0 THEN ws.prev_sql_addr
            ELSE ws.sql_address
          END)
           Waiting_sql_address,
         bs.program
           Blocking_App,
         ws.program
           Waiting_App,
         bs.machine
           Blocking_Machine,
         ws.machine
           Waiting_Machine,
         bs.osuser
           Blocking_OS_User,
         ws.osuser
           Waiting_OS_User,
         ws.serial#
           WSerial#,
         DECODE (wk.TYPE,
                 'MR', 'Media Recovery',
                 'RT', 'Redo Thread',
                 'UN', 'USER Name',
                 'TX', 'Transaction',
                 'TM', 'DML',
                 'UL', 'PL/SQL USER LOCK',
                 'DX', 'Distributed Xaction',
                 'CF', 'Control FILE',
                 'IS', 'Instance State',
                 'FS', 'FILE SET',
                 'IR', 'Instance Recovery',
                 'ST', 'Disk SPACE Transaction',
                 'TS', 'Temp Segment',
                 'IV', 'Library Cache Invalidation',
                 'LS', 'LOG START OR Switch',
                 'RW', 'ROW Wait',
                 'SQ', 'Sequence Number',
                 'TE', 'Extend TABLE',
                 'TT', 'Temp TABLE',
                 wk.TYPE)
           lock_type,
         DECODE (hk.lmode,
                 0, 'None',
                 1, 'NULL',
                 2, 'ROW-S (SS)',
                 3, 'ROW-X (SX)',
                 4, 'SHARE',
                 5, 'S/ROW-X (SSX)',
                 6, 'EXCLUSIVE',
                 TO_CHAR (hk.lmode))
           mode_held,
         DECODE (wk.request,
                 0, 'None',
                 1, 'NULL',
                 2, 'ROW-S (SS)',
                 3, 'ROW-X (SX)',
                 4, 'SHARE',
                 5, 'S/ROW-X (SSX)',
                 6, 'EXCLUSIVE',
                 TO_CHAR (wk.request))
           mode_requested,
         TO_CHAR (hk.id1)
           lock_id1,
         TO_CHAR (hk.id2)
           lock_id2,
         DECODE (hk.BLOCK,
                 0, 'NOT Blocking',     /* Not blocking any other processes */
                 1, 'Blocking',         /* This lock blocks other processes */
                 2, 'Global',      /* This lock is global, so we can't tell */
                 TO_CHAR (hk.BLOCK))
           blocking_others,
         (SELECT u.username
            FROM all_users u
           WHERE bs.username = u.username)
           Blocking_User_pseudoname,
         'a'--lll_get_User_Dept_Name (bs.username)
           Blocking_User_Dept_Name
    FROM v$lock  hk,
         (SELECT s.audsid,
                 s.sid,
                 s.serial#,
                 s.username,
                 s.osuser,
                 s.machine,
                 s.program,
                 s.sql_address,
                 s.prev_sql_addr,
                 s.sql_hash_value,
                 s.prev_hash_value
            FROM v$session s, v$process p
           WHERE s.paddr = p.addr) bs,
         v$lock  wk,
         (SELECT s.audsid,
                 s.sid,
                 s.serial#,
                 s.username,
                 s.osuser,
                 s.machine,
                 s.program,
                 s.sql_address,
                 s.prev_sql_addr,
                 s.sql_hash_value,
                 s.prev_hash_value
            FROM v$session s, v$process p
           WHERE s.paddr = p.addr) ws
   WHERE     hk.block = 1
         AND hk.lmode != 0
         AND hk.lmode != 1
         AND wk.request != 0
         AND wk.TYPE(+) = hk.TYPE
         AND wk.id1(+) = hk.id1
         AND wk.id2(+) = hk.id2
         AND hk.sid = bs.sid(+)
         AND wk.sid = ws.sid(+)
         AND (bs.username IS NOT NULL)
         AND (bs.username <> 'SYSTEM')
         AND (bs.username <> 'SYS');