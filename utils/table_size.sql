WITH
    tt
    AS
        (  SELECT segment_name, ROUND (SUM (bytes) / 1024 / 1024 / 1024) "Gb"
             FROM user_segments
            WHERE segment_type = 'TABLE'
         GROUP BY segment_name),
    ts
    AS
        (  SELECT segment_name, ROUND (SUM (bytes) / 1024 / 1024 / 1024) "Gb"
             FROM user_segments
            WHERE segment_type = 'TABLE PARTITION'
         GROUP BY segment_name),
    tall
    AS
        (SELECT * FROM tt
         UNION ALL
         SELECT * FROM ts)
  SELECT segment_name,round("Gb") "Gb",round(sum("Gb") over ()) sum_gb
    FROM tall
ORDER BY "Gb" DESC;

select segment_name,sum(bytes)/1024/1024/1024 "Gb" from user_segments where segment_type = 'TABLE' 
group by segment_name
order by "Gb" desc; 

select segment_name,partition_name,sum(bytes)/1024/1024/1024 "Gb" from user_segments where segment_type = 'TABLE PARTITION' 
group by segment_name,partition_name
order by "Gb" desc;

select * from user_segments where segment_type = 'TABLE PARTITION';

