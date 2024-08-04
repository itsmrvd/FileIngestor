CREATE OR REPLACE PACKAGE file_ingestor IS
    PROCEDURE ingest_file (
        file_id   NUMBER,
        file_name VARCHAR2
    );

END file_ingestor;
/

