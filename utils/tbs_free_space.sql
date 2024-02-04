select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments
group by tablespace_name) tu
where df.tablespace_name = tu.tablespace_name ;




select b.tablespace_name, tbs_size SizeMb, a.free_space FreeMb

from  (select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space

       from dba_free_space

       group by tablespace_name) a,

      (select tablespace_name, sum(bytes)/1024/1024 as tbs_size

       from dba_data_files

       group by tablespace_name) b

where a.tablespace_name(+)=b.tablespace_name;



select sum(bytes)/1024 kbytes_alloc, tablespace_name
from sys.dba_temp_files
group by tablespace_name





select b.tablespace_name, tbs_size SizeMb, a.free_space FreeMb
from
(select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space
from dba_free_space group by tablespace_name) a,
(select tablespace_name, sum(bytes)/1024/1024 as tbs_size
from dba_data_files group by tablespace_name
UNION
select tablespace_name, sum(bytes)/1024/1024 tbs_size
from dba_temp_files
group by tablespace_name ) b
where a.tablespace_name(+)=b.tablespace_name;



column "Tablespace" format a13
column "Used MB"    format 99,999,999
column "Free MB"    format 99,999,999
column "Total MB"   format 99,999,999
select
   fs.tablespace_name                          "Tablespace",
   (df.totalspace - fs.freespace)              "Used MB",
   fs.freespace                                "Free MB",
   df.totalspace                               "Total MB",
   round(100 * (fs.freespace / df.totalspace)) "Pct. Free"
from
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) TotalSpace
   from
      dba_data_files
   group by
      tablespace_name
   ) df,
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) FreeSpace
   from
      dba_free_space
   group by
      tablespace_name
   ) fs
where
   df.tablespace_name = fs.tablespace_name;
SELECT  a.tablespace_name,
    ROUND (((c.BYTES - NVL (b.BYTES, 0)) / c.BYTES) * 100,2) percentage_used,
    c.BYTES / 1024 / 1024 space_allocated,
    ROUND (c.BYTES / 1024 / 1024 - NVL (b.BYTES, 0) / 1024 / 1024,2) space_used,
    ROUND (NVL (b.BYTES, 0) / 1024 / 1024, 2) space_free, 
    c.DATAFILES
  FROM dba_tablespaces a,
       (    SELECT   tablespace_name, 
                  SUM (BYTES) BYTES
           FROM   dba_free_space
       GROUP BY   tablespace_name
       ) b,
      (    SELECT   COUNT (1) DATAFILES, 
                  SUM (BYTES) BYTES, 
                  tablespace_name
           FROM   dba_data_files
       GROUP BY   tablespace_name
    ) c
  WHERE b.tablespace_name(+) = a.tablespace_name 
    AND c.tablespace_name(+) = a.tablespace_name
ORDER BY NVL (((c.BYTES - NVL (b.BYTES, 0)) / c.BYTES), 0) DESC;


--Size of All Table Space

--1. Used Space
SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024/1024, '99,999,990.99') AS "USED SPACE(IN GB)" FROM USER_SEGMENTS GROUP BY TABLESPACE_NAME
--2. Free Space
SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024/1024, '99,999,990.99') AS "FREE SPACE(IN GB)" FROM   USER_FREE_SPACE GROUP BY TABLESPACE_NAME

--3. Both Free & Used
SELECT USED.TABLESPACE_NAME, USED.USED_BYTES AS "USED SPACE(IN GB)",  FREE.FREE_BYTES AS "FREE SPACE(IN GB)"
FROM
(SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024/1024, '99,999,990.99') AS USED_BYTES FROM USER_SEGMENTS GROUP BY TABLESPACE_NAME) USED
INNER JOIN
(SELECT TABLESPACE_NAME,TO_CHAR(SUM(NVL(BYTES,0))/1024/1024/1024, '99,999,990.99') AS FREE_BYTES FROM  USER_FREE_SPACE GROUP BY TABLESPACE_NAME) FREE
ON (USED.TABLESPACE_NAME = FREE.TABLESPACE_NAME);




SELECT TABLESPACE_NAME,SUM(BYTES)/1024/1024/1024 "FREE SPACE(GB)"
FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME;


