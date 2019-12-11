declare
    ticket varchar(5) := '15745';
    type array_t is varray(2) of varchar2(30);
    OriginTables array_t := array_t('TABLE1','TABLE2');
begin
    for i in 1..OriginTables.count loop
        execute immediate('CREATE TABLE '||OriginTables(i) || ticket ||' AS (
            SELECT *
                FROM '||OriginTables(i) ||'
                WHERE 1=1
            )');
    end loop;
end;
/
