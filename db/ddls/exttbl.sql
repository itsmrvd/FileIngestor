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
            MISSING FIELD VALUES ARE NULL 
            REJECT ROWS WITH ALL NULL FIELDS  
     )   
   LOCATION ('emp_YYYYMMDD.csv')
   
  ) REJECT LIMIT UNLIMITED; 

