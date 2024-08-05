BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE delimited_file_types';
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode <> -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE fixed_width_file_types';
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode <> -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE file_types';
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode <> -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE file_types (
    file_type_id          NUMBER(*, 0),
    file_type_name        VARCHAR2(100),
    file_type_description VARCHAR2(200)
);

CREATE TABLE delimited_file_types (
    file_type_id       NUMBER,
    delimiter          VARCHAR2(1),
    enclosure          VARCHAR2(1),
    parse_by_delimiter VARCHAR2(1),
    parse_by_enclosure VARCHAR2(1)
);

CREATE TABLE fixed_width_file_types (
    file_type_id             NUMBER,
    fixed_or_variable_length VARCHAR2(1),
    min_record_length        NUMBER(*, 0),
    max_record_length        NUMBER(*, 0)
);

DROP TABLE files;

CREATE TABLE files (
    file_id                  NUMBER,
    file_name                VARCHAR2(100),
    file_type_id             NUMBER,
    first_column             VARCHAR2(100),
    header_applicable        VARCHAR2(1),
    header_identifier_chars  VARCHAR2(50),
    trailer_applicable       VARCHAR2(1),
    trailer_identifier_chars VARCHAR2(50),
    file_directory           VARCHAR2(100),
    ext_table                VARCHAR(100),
    stage_table              VARCHAR(100),
    error_table              VARCHAR2(100)
);

DROP TABLE file_columns;

CREATE TABLE file_columns (
    file_id          NUMBER,
    column_seq       NUMBER,
    column_name      VARCHAR2(100),
    field_start_pos  NUMBER,
    field_length     NUMBER,
    data_type        VARCHAR2(100),
    date_length      NUMBER,
    data_format      VARCHAR2(100),
    sys_column       VARCHAR2(1),
    sys_column_value VARCHAR2(100)
);

CREATE DIRECTORY employment AS '/home/oracle/file_ingestor/employment/';

drop table employment_ext;
CREATE TABLE employment_ext
  (
    series_reference  VARCHAR2(4000),
    period_1          VARCHAR2(4000),
    data_value        VARCHAR2(4000),
    suppressed        VARCHAR2(4000),
    status            VARCHAR2(4000),
    units             VARCHAR2(4000),
    magnitude         VARCHAR2(4000),
    subject           VARCHAR2(4000),
    group_1           VARCHAR2(4000),
    series_title_1    VARCHAR2(4000),
    series_title_2    VARCHAR2(4000),
    series_title_3    VARCHAR2(4000),
    series_title_4    VARCHAR2(4000),
    series_title_5    VARCHAR2(4000)
    )
   ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY employment
   ACCESS PARAMETERS
     (      RECORDS DELIMITED BY NEWLINE
            FIELDS CSV WITHOUT EMBEDDED 
            TERMINATED BY ','
            OPTIONALLY ENCLOSED BY '"'
            MISSING FIELD VALUES ARE NULL 
            REJECT ROWS WITH ALL NULL FIELDS  
     )   
   LOCATION ('emp_YYYYMMDD.csv')
   
  ) REJECT LIMIT UNLIMITED;  

drop table employment_stg;
CREATE TABLE employment_stg (
    file_ingestion_id NUMBER,
    record_sequence   NUMBER,
    record_type       NUMBER,
    insert_time       TIMESTAMP,
    series_reference  VARCHAR2(4000),
    period_1          VARCHAR2(4000),
    data_value        VARCHAR2(4000),
    suppressed        VARCHAR2(4000),
    status            VARCHAR2(4000),
    units             VARCHAR2(4000),
    magnitude         VARCHAR2(4000),
    subject           VARCHAR2(4000),
    group_1           VARCHAR2(4000),
    series_title_1    VARCHAR2(4000),
    series_title_2    VARCHAR2(4000),
    series_title_3    VARCHAR2(4000),
    series_title_4    VARCHAR2(4000),
    series_title_5    VARCHAR2(4000)
);
