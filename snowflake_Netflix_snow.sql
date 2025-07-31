--configuration of snowpipe code

CREATE STORAGE INTEGRATION my_first_storage_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::351291607193:role/demo-sf-role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://netlixproject/netflix/');

    
--------------------------------------------------------------------------    

DESC STORAGE INTEGRATION my_first_storage_integration;
//WHENEVER YOU KINDA A DROP IT AN CREATE THE SAME STORAGE INTEGRATION MAY IT BE THE SAME METADATA IT WILL GIVE YOU ANOTHER EXTERNAL ID 

--------------------------------------------------------------------------

USE DATABASE SNOWFLAKE_LEARNING_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  --SKIP_HEADER = 1
  PARSE_HEADER = TRUE;

CREATE STAGE my_s3_stage
    STORAGE_INTEGRATION = my_first_storage_integration
    URL = 's3://netlixproject/netflix/'
    FILE_FORMAT = my_csv_format;

ALTER STAGE my_s3_stage
SET FILE_FORMAT = my_csv_format;


--DROP STORAGE INTEGRATION IF EXISTS my_first_storage_integration;


---------- ---------------------------------------


CREATE OR REPLACE TABLE NETFLIX (
  show_id STRING,
  type STRING,
  title STRING,
  director STRING,
  cast STRING,
  country STRING,
  date_added STRING,
  release_year NUMBER,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING,
  insertion_timestamp TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP
);


------------------------------------------------

DROP PIPE IF EXISTS demo_netflix_data;

CREATE OR REPLACE PIPE demo_netflix_data
  AUTO_INGEST = TRUE
  AS
  COPY INTO NETFLIX
  FROM @my_s3_stage/netflix/;
  FILE_FORMAT = my_csv_format
  ON_ERROR = 'CONTINUE'
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


SELECT * FROM NETFLIX ;
