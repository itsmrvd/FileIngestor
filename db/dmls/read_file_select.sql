SELECT
*
FROM
    EXTERNAL ( ( 
    col_001   VARCHAR2(4000), 
    col_002   VARCHAR2(4000), 
    col_003   VARCHAR2(4000), 
    col_004   VARCHAR2(4000), 
    col_005   VARCHAR2(4000), 
    col_006   VARCHAR2(4000), 
    col_007   VARCHAR2(4000), 
    col_008   VARCHAR2(4000), 
    col_009   VARCHAR2(4000), 
    col_010   VARCHAR2(4000), 
    col_011   VARCHAR2(4000), 
    col_012   VARCHAR2(4000), 
    col_013   VARCHAR2(4000), 
    col_014   VARCHAR2(4000)
    ) 
    TYPE oracle_loader
        DEFAULT DIRECTORY employment ACCESS PARAMETERS (
            RECORDS DELIMITED BY NEWLINE
            FIELDS CSV WITHOUT EMBEDDED 
            TERMINATED BY ',' 
            MISSING FIELD VALUES ARE NULL 
            REJECT ROWS WITH ALL NULL FIELDS
        ) LOCATION ( 'emp_20240729.csv' )
        REJECT LIMIT UNLIMITED
    );