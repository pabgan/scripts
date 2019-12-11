declare
    ticket varchar(5) := '15745';
    type array_t is varray(2) of varchar2(30);
    OriginTables array_t := array_t('TABLE1','TABLE2');
begin
    for i in 1..OriginTables.count loop
        execute immediate('TRUNCATE TABLE '|| OriginTables(i));
        execute immediate('INSERT INTO '||OriginTables(i)||' SELECT * FROM '||OriginTables(i)||ticket);
--        execute immediate('DROP TABLE '||OriginTables(i) || ticket);
    end loop;
end;
/

