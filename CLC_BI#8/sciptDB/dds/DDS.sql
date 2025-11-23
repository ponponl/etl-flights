-- Drop and recreate the database
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DDS_Airline')
BEGIN
    ALTER DATABASE DDS_Airline SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DDS_Airline;
END
GO

CREATE DATABASE DDS_Airline;
GO

USE DDS_Airline;
GO

-- =============================================
-- 1. TẠO CÁC BẢNG DIMENSION (CHIỀU)
-- =============================================

-- Bảng Hãng bay
CREATE TABLE Dim_Airline (
    Airline_ID INT PRIMARY KEY,  -- Mã IATA
	Airline_NK VARCHAR(10) NOT NULL,
    Airline_Name VARCHAR(255),
	SOURCE_ID VARCHAR(50),
    STATUS INT DEFAULT 1,
	CREATED DATETIME2,
    MODIFIED DATETIME2,

);
GO

-- Bảng Sân bay
CREATE TABLE Dim_Airport (
    Airport_ID INT PRIMARY KEY,  -- Mã IATA
	Airport_NK VARCHAR(10) NOT NULL,
    Airport_Name VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50),
    Latitude DECIMAL(10, 6),
    Longitude DECIMAL(10, 6),
	SOURCE_ID VARCHAR(50),
    STATUS INT DEFAULT 1,
	CREATED DATETIME2,
    MODIFIED DATETIME2,
);
GO

-- Bảng Nguyên nhân hủy (Dữ liệu tĩnh)
CREATE TABLE Dim_Reason (
    Reason_ID CHAR(1) PRIMARY KEY,
    Description VARCHAR(100),
    STATUS INT DEFAULT 1,
	CREATED DATETIME2,
    MODIFIED DATETIME2,
);
GO

-- Bảng Thời gian (Calendar)
CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY,       -- 20150101
    Full_Date DATE,                 -- 2015-01-01
    Year INT,
    Quarter INT,
    Month_Num INT,
    Month_Name VARCHAR(20),
    Day_Of_Week VARCHAR(20),
    Is_Weekend BIT,
    STATUS INT DEFAULT 1,
	CREATED DATETIME2,
    MODIFIED DATETIME2,
);
GO

-- =============================================
-- 2. TẠO BẢNG FACT (SỰ KIỆN)
-- =============================================

CREATE TABLE Fact_Flights (
    Flight_ID INT PRIMARY KEY,
    
    -- Foreign Keys
    Date_Key INT,
    Airline_ID INT,
    Origin_Airport_ID INT,
    Dest_Airport_ID INT,
    Cancel_Reason_ID CHAR(1),

    -- Business Keys & Attributes
    Flight_Number VARCHAR(20),
    Tail_Number VARCHAR(20),
    Scheduled_Dep_Time INT,  -- '05:56'

    -- Metrics (Facts)
    Dep_Delay DECIMAL(10,2),
    Arr_Delay DECIMAL(10,2),
    Air_Time DECIMAL(10,2),
    Distance INT,
    Taxi_Out DECIMAL(10,2),
    Taxi_In DECIMAL(10,2),
    
    -- Delay Breakdown
    Delay_System DECIMAL(10,2),
    Delay_Security DECIMAL(10,2),
    Delay_Airline DECIMAL(10,2),
    Delay_Weather DECIMAL(10,2),
    Delay_LateAircraft DECIMAL(10,2),
    
    -- Flags
    Is_Cancelled BIT,
    Is_Diverted BIT,

	SOURCE_ID VARCHAR(50),
    STATUS INT DEFAULT 1,
	CREATED DATETIME2,
    MODIFIED DATETIME2,

    -- Constraints
    FOREIGN KEY (Date_Key) REFERENCES Dim_Date(Date_Key),
    FOREIGN KEY (Airline_ID) REFERENCES Dim_Airline(Airline_ID),
    FOREIGN KEY (Origin_Airport_ID) REFERENCES Dim_Airport(Airport_ID),
    FOREIGN KEY (Dest_Airport_ID) REFERENCES Dim_Airport(Airport_ID)
    -- Lưu ý: Cancel_Reason_ID có thể NULL nên cẩn thận khi tạo FK nếu dữ liệu chưa sạch
);
GO

-- =============================================
-- 3. NẠP DỮ LIỆU TĨNH VÀO DIMENSION
-- =============================================

-- Nạp Dim_Reason
INSERT INTO Dim_Reason VALUES 
('A', 'Carrier', 1), 
('B', 'Weather', 1), 
('C', 'National Air System', 1), 
('D', 'Security', 1);
GO

-- Nạp Dim_Date (Script tự động sinh ngày cho năm 2015)
DECLARE @StartDate DATE = '2015-01-01';
DECLARE @EndDate DATE = '2015-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date (Date_Key, Full_Date, Year, Quarter, Month_Num, Month_Name, Day_Of_Week, Is_Weekend)
    SELECT 
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT), -- Date_Key
        @StartDate,
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        CASE WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1 ELSE 0 END; -- 1=Sun, 7=Sat (Tùy server setting)

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

PRINT 'Database DDS_Airline created successfully with all dimension and fact tables!';
GO