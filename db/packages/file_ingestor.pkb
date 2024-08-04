CREATE OR REPLACE PACKAGE BODY file_ingestor IS

    file_ingestion_status_rec file_ingestion_status%rowtype;
    file_rec                  files%rowtype;

    PROCEDURE init (
        file_id   NUMBER,
        file_name VARCHAR2
    ) IS
    BEGIN
        SELECT
            *
        INTO file_rec
        FROM
            files
        WHERE
            file_id = file_id;

        file_ingestion_status_rec.file_id := file_id;
        file_ingestion_status_rec.file_name := file_name;
--        file_rec.stage_table := 'employment_stg';
--        file_rec.ext_table := 'employment_ext';
--        file_rec.first_column := 'series_reference';
--        file_rec.header_identifier_chars := 'Series_reference';
--        file_rec.trailer_identifier_chars := 'Total_records';
    END init;

    PROCEDURE log_ingestion_satus (
        file_ingestion_status_row IN OUT NOCOPY file_ingestion_status%rowtype
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        IF file_ingestion_status_row.file_ingestion_id IS NULL THEN
            file_ingestion_status_row.file_ingestion_id := file_ingestion_seq.nextval;
            INSERT INTO file_ingestion_status (
                file_ingestion_id,
                file_id,
                file_name,
                current_status
            ) VALUES (
                file_ingestion_status_row.file_ingestion_id,
                file_ingestion_status_row.file_id,
                file_ingestion_status_row.file_name,
                'STARTED'
            );

        ELSE
            UPDATE file_ingestion_status
            SET
                file_id = file_ingestion_status_row.file_id,
                file_name = file_ingestion_status_row.file_name,
                current_status = file_ingestion_status_row.current_status,
                validation_status = file_ingestion_status_row.validation_status,
                total_rows = file_ingestion_status_row.total_rows,
                ingested_rows = file_ingestion_status_row.ingested_rows,
                last_updated = file_ingestion_status_row.last_updated,
                last_updated_by = file_ingestion_status_row.last_updated_by
            WHERE
                file_ingestion_id = file_ingestion_status_row.file_ingestion_id;

        END IF;

        COMMIT;
    END log_ingestion_satus;

    PROCEDURE load_csv (
        file_ingestion_status_row IN OUT NOCOPY file_ingestion_status%rowtype,
        file_row                  IN OUT NOCOPY files%rowtype
    ) IS
        stmt VARCHAR2(32767);
    BEGIN
        stmt := 'BEGIN
                 INSERT INTO '
                || file_row.stage_table
                || ' SELECT * FROM '
                || file_row.ext_table
                || ' EXTERNAL MODIFY ( LOCATION ( '''
                || file_ingestion_status_row.file_name
                || ''' ) )
                 WHERE '
                || file_row.first_column
                || ' NOT LIKE '''
                || file_row.header_identifier_chars
                || '%'' AND   '
                || file_row.first_column
                || ' NOT LIKE '''
                || file_row.trailer_identifier_chars
                || '%'';
                 END;';

        EXECUTE IMMEDIATE stmt;
        COMMIT;
    END load_csv;

    PROCEDURE ingest_file (
        file_id   NUMBER,
        file_name VARCHAR2
    ) IS
    BEGIN
        init(file_id, file_name);
        log_ingestion_satus(file_ingestion_status_rec);
        load_csv(file_ingestion_status_rec, file_rec);
        log_ingestion_satus(file_ingestion_status_rec);
    END ingest_file;

END file_ingestor;
/

