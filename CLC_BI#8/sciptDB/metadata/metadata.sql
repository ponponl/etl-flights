-- Force close all connections and drop database if it exists
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'metadata_airline')
BEGIN
    -- Set database to single user mode and rollback any active transactions
    ALTER DATABASE metadata_airline SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    -- Drop the database
    DROP DATABASE metadata_airline;
END
GO

-- Create the database
CREATE DATABASE metadata_airline;
GO

-- Now switch to the new database
USE metadata_airline;
GO

-- Log each ETL_Process
CREATE TABLE ETL_Process_Log (
    Process_ID INT IDENTITY(1,1) PRIMARY KEY,
    Process_Name NVARCHAR(200) NOT NULL,
    Source_System NVARCHAR(100) NULL,
    Target_System NVARCHAR(100) NULL,
    Start_Time DATETIME NOT NULL DEFAULT(GETDATE()),
    End_Time DATETIME NULL,
    Status NVARCHAR(50) NULL,              -- e.g., Success, Failed, In Progress
    Row_Extracted INT NULL,
    Row_Inserted INT NULL,
    Row_Updated INT NULL,
    Row_F1 INT NULL,                       -- Added for Flights1
    Row_F2 INT NULL,                       -- Added for Flights2
    Row_F3 INT NULL,                       -- Added for Flights3
    Row_Airline INT NULL,                  -- Added for Airlines
    Row_Airport INT NULL,                  -- Added for Airport
    Error_Message NVARCHAR(MAX) NULL,
    Run_By NVARCHAR(100) NULL,
    Created_At DATETIME DEFAULT(GETDATE())
);
GO

CREATE TABLE ETL_Metadata (
    Table_Name NVARCHAR(200) PRIMARY KEY,
    LSET DATETIME NULL,
    Last_Extract_ID BIGINT NULL,
    Change_Detection_Column NVARCHAR(100) NULL,   -- e.g. UpdatedDate, ModifiedOn
    Load_Type NVARCHAR(50) DEFAULT('Incremental'), -- Full or Incremental
    Is_Initial_Load_Completed BIT DEFAULT(0),
    Watermark_Value NVARCHAR(100) NULL,
    Status NVARCHAR(50) NULL,                     -- e.g., Success, Failed
    Last_Run_ID INT NULL REFERENCES dbo.ETL_Process_Log(Process_ID),
    Updated_At DATETIME DEFAULT(GETDATE())
);
GO

-- Create NDS_ETL_Metadata table with similar schema
CREATE TABLE NDS_ETL_Metadata (
    Table_Name NVARCHAR(200) PRIMARY KEY,
    LSET DATETIME NULL,
    Last_Extract_ID BIGINT NULL,
    Change_Detection_Column NVARCHAR(100) NULL,   -- e.g. UpdatedDate, ModifiedOn
    Load_Type NVARCHAR(50) DEFAULT('Incremental'), -- Full or Incremental
    Is_Initial_Load_Completed BIT DEFAULT(0),
    Watermark_Value NVARCHAR(100) NULL,
    Status NVARCHAR(50) NULL,                     -- e.g., Success, Failed
    Last_Run_ID INT NULL REFERENCES dbo.ETL_Process_Log(Process_ID),
    Updated_At DATETIME DEFAULT(GETDATE())
);
GO

CREATE TABLE dbo.ETL_Error_Log (
    Error_ID INT IDENTITY(1,1) PRIMARY KEY,
    Process_ID INT REFERENCES dbo.ETL_Process_Log(Process_ID),
    Table_Name NVARCHAR(200) NOT NULL,
    Source_Key NVARCHAR(200) NULL,
    Error_Message NVARCHAR(MAX) NOT NULL,
    Error_Time DATETIME DEFAULT(GETDATE()),
    Row_Data NVARCHAR(MAX) NULL
);
GO

-- Initialize metadata for all tables
INSERT INTO ETL_Metadata (
    Table_Name,
    LSET,
    Change_Detection_Column,
    Load_Type,
    Is_Initial_Load_Completed,
    Status
)
VALUES
('Airlines', '1990-11-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized'),
('Airport',  '1990-11-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized'),
('Flights1', '1990-11-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized'),
('Flights2', '1990-11-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized'),
('Flights3', '1990-11-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized');
GO

-- Initialize metadata for NDS tables (based on screenshot showing NDS_Airlines, NDS_Airports, NDS_Flights)
INSERT INTO NDS_ETL_Metadata (
    Table_Name,
    LSET,
    Change_Detection_Column,
    Load_Type,
    Is_Initial_Load_Completed,
    Status
)
VALUES
('NDS_Airlines', '1995-01-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized'),
('NDS_Airports', '1995-01-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized'),
('NDS_Flights',  '1995-01-01T00:00:00', 'UpdatedDate', 'Incremental', 1, 'Initialized');
GO

-- Verify the setup
SELECT * FROM ETL_Metadata;
SELECT * FROM NDS_ETL_Metadata;
GO