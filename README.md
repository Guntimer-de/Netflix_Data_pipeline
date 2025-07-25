# End-to-End Data Pipeline: AWS S3 ➝ Snowflake (via Snowpipe)

Project Description
In this project, I built an automated data ingestion pipeline where Netflix metadata in CSV format is loaded from AWS S3 directly into Snowflake using Snowpipe. The objective was to simulate a real-time ingestion scenario and understand how Snowflake integrates with AWS for seamless data flow. This kind of setup is commonly used in production environments to reduce manual intervention and ensure that new data is always available for analysis.

STEP 1: Understanding the Dataset
The first step was to explore the Netflix dataset, which includes information about shows, movies, genres, release years, and more. I made sure the CSV was clean and ready to upload — each column matched what I wanted in the Snowflake table.

STEP 2: Uploading to AWS S3
I created an S3 bucket and uploaded the CSV files. This bucket would act as the source of truth for all new data uploads going into the pipeline.

STEP 3: Setting Up Permissions on AWS
To allow Snowflake to access the data in S3, I created an IAM role with the right permissions (like GetObject, ListBucket) and updated the trust policy so Snowflake could assume that role. This is a key part of making the connection secure.

STEP 4: Creating Snowflake Integration
Inside Snowflake, I set up a storage integration which acts as a bridge between Snowflake and S3. This step ensures Snowflake knows how to securely talk to AWS.

STEP 5: Creating the Table and Stage
I created a table to hold the Netflix data and then created a stage that points to the S3 bucket. The stage is where Snowflake "looks" for the files before loading them.

STEP 6: Setting Up Snowpipe
I then created a Snowpipe — a service that automatically loads new files as soon as they're uploaded to the S3 bucket. By enabling AUTO_INGEST, Snowflake uses event notifications from S3 to start loading data without any manual work.

STEP 7: Connecting S3 Notifications
This was a critical step. I copied the notification_channel from Snowpipe and added it to the S3 bucket’s event notification settings. This ensures Snowflake gets notified every time a new file is uploaded.

Testing the Pipeline
To make sure everything worked, I uploaded a fresh file to S3 and checked whether it appeared in the Snowflake table. The data loaded successfully within seconds, confirming that the pipeline was working end-to-end.


