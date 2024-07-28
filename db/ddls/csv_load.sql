CREATE OR REPLACE PROCEDURE csv_load (
    file_name VARCHAR2
) IS
stage_table VARCHAR2(100) := 'employment_stg';
ext_table VARCHAR2(100) := 'employment_ext';
first_column VARCHAR2(100) := 'series_reference';
header_id VARCHAR2(100) := 'Series_reference';
trailer_id VARCHAR2(100) := 'Total_records';
stmt VARCHAR2(32767);
BEGIN

stmt :=
'BEGIN
INSERT INTO '||stage_table||'
        SELECT
            *
        FROM
            '||ext_table||' EXTERNAL MODIFY ( LOCATION ( '''||file_name||''' ) )
        WHERE
            '||first_column||' NOT LIKE '''||header_id||'%''
            AND '||first_column||' NOT LIKE '''||trailer_id||'%'';
END;';
execute IMMEDIATE stmt;
END;
/

truncate table employment_stg;
select * from employment_stg;
--insert into employment_stg
select * from employment_ext EXTERNAL MODIFY ( LOCATION ( 'emp_20240729.csv' ) );

set serveroutput on
begin
csv_load('machine-readable-business-employment-data-mar-2024-quarter.csv');
commit;
end;
/