 SELECT a.sid
             Sid,
           NVL (b.username, '_' || b.schemaname)
             usr,
           NVL (
             NVL ( (b.username),
                  ': ' || b.program || ':' || b.TYPE),
             'Итого')
             Name,
              TO_CHAR (
                SUM (DECODE (a.statistic#, 21, a.VALUE / 1024 / 1024, NULL)),
                '999,999,990.99')
           || ' M'
             Current_UGA_Desc,
              TO_CHAR (
                SUM (DECODE (a.statistic#, 26, a.VALUE / 1024 / 1024, NULL)),
                '999,999,990.99')
           || ' M'
             Current_PGA_Desc,
              TO_CHAR (
                SUM (DECODE (a.statistic#, 22, a.VALUE / 1024 / 1024, NULL)),
                '999,999,990.99')
           || ' M'
             Max_UGA_Desc,
              TO_CHAR (
                SUM (DECODE (a.statistic#, 27, a.VALUE / 1024 / 1024, NULL)),
                '999,999,990.99')
           || ' M'
             Max_PGA_Desc,
           SUM (DECODE (a.statistic#, 21, a.VALUE / 1024 / 1024, NULL))
             Current_UGA                                         -- "15" < 10g
                        ,
           SUM (DECODE (a.statistic#, 26, a.VALUE / 1024 / 1024, NULL))
             Current_PGA                                         -- "20" < 10g
                        ,
           SUM (DECODE (a.statistic#, 22, a.VALUE / 1024 / 1024, NULL))
             Max_UGA                                             -- "16" < 10g
                    ,
           SUM (DECODE (a.statistic#, 27, a.VALUE / 1024 / 1024, NULL))
             Max_PGA                                             -- "21" < 10g
                    ,
           GREATEST (SUM (DECODE (a.statistic#, 21, a.VALUE, NULL)),
                     SUM (DECODE (a.statistic#, 26, a.VALUE, NULL)))
             gr
      FROM v$sesstat a, v$session b
     WHERE     a.sid = b.sid
           AND a.statistic# IN (21,
                                22,
                                26,
                                27)
  GROUP BY GROUPING SETS (
             (a.sid,
              NVL (b.username, '_' || b.schemaname),
              NVL ( (b.username),
                   ': ' || b.program || ':' || b.TYPE)),
             (  ))
  ORDER BY gr DESC, 3, 1;