declare
    vMaxDate date := to_date('01.10.2021','DD.MM.RRRR');
    vTableOwner varchar2(100) := 'RISK_SOURCE';
    vTableName varchar2(100) := 'S02_CLPS_QUEUE_MQ';
    vTempTableName varchar2(100) ; 

    type tPrtCur is ref cursor;
    cPrtCur tPrtCur;
    type tPrtRec is record
    (
    partition_name varchar2(100),
    max_date date
    );
    rPrtRec tPrtRec;
    vp varchar2(100);
    vDropStatement    varchar2(4000);
    vPrtCurStatement   varchar2(4000);
begin
    vp := '17';
    vTempTableName := substr('X$PRT'||vTableName||to_char(sysdate,'RRMMDDHH24MiSS'),1,30);
    vp := '18';
    --dbms_output.put_line('vTempTableName '||vTempTableName);
    vDropStatement := 'drop table '||vTempTableName||' ';
    --dbms_output.put_line(vDropStatement);
    
    begin execute immediate vDropStatement; exception when others then  null; 
    --dbms_output.put_line(SqlErrM);  
    end;
    
    execute immediate 'create table '||vTempTableName||' as '||
    'select table_owner,table_name, partition_name,to_lob(high_value) high_value '||
                    ' from all_tab_partitions p '||
                   ' where p.table_owner = '''||vTableOwner||''' '|| 
                    ' and p.table_name = '''||vTableName||''' ';
    vp := '25';  
    vPrtCurStatement := 'select partition_name, to_date(regexp_substr(to_char(high_value),''\d{4}-\d{2}-\d{2}''),''YYYY-MM-DD'') high_value '||
                        'from '||vTempTableName||
                        ' order by high_value';              
    open cPrtCur for vPrtCurStatement;
    loop
        fetch cPrtCur into rPrtRec;
        if rPrtRec.max_date < vMaxDate then
            dbms_output.put_line('Alter table '||vTableName||' drop partition '||rPrtRec.Partition_name||'; -- '||rPrtRec.max_date);
        end if;
        exit when cPrtCur%NotFound;
    end loop;

    close cPrtCur;                
                    
    execute immediate vDropStatement; 
    
    for vv in (select * from user_indexes where table_name = vTableName) loop
        dbms_output.put_line('alter index '||vv.index_name||' rebuild; ');
    
    end loop;

exception when others then

    if cPrtCur%ISOPEN then
        close cPrtCur;
    end if;    
    dbms_output.put_line('vp '||vp||' Error '||SqlErrM);
    
end;             
                 --and p.partition_name not in ('SYS_P79179', 'P_START')
select aa.*, to_date(regexp_substr(to_char(high_value),'\d{4}-\d{2}-\d{2}'),'YYYY-MM-DD') high_value from   x$partitions aa; 
select * from X$PRTS02_CLPS_QUEUE_MQ22012712;              