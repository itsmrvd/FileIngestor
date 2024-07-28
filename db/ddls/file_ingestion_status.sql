DROP TABLE file_ingestion_status;

CREATE TABLE file_ingestion_status (
    file_ingestion_id NUMBER,
    file_id           NUMBER,
    file_name         VARCHAR2(100),
    current_status    VARCHAR2(20),
    validation_status VARCHAR2(1),
    total_rows        NUMBER,
    ingested_rows     NUMBER,
    last_updated      TIMESTAMP,
    last_updated_by   VARCHAR2(30)
);

drop table FILE_INGESTION_STATUSES;
  CREATE TABLE FILE_INGESTION_STATUSES 
   (	STATUS_ID NUMBER, 
	STATUS_NAME VARCHAR2(20) 
   ) ;

