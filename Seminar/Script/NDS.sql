
CREATE DATABASE NDS_Seminar;
GO
USE NDS_Seminar;
GO

CREATE TABLE dbo.Customer_NDS (
    CustomerSK INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key

    CustomerID NVARCHAR(50) UNIQUE NOT NULL,   -- Business Key
    CustomerName NVARCHAR(255),
    Segment NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    StateProvince NVARCHAR(50),
    
    CreateDate DATETIME,
    UpdateDate DATETIME
);
GO

CREATE TABLE dbo.Product_NDS (
    ProductSK INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate Key

    ProductID NVARCHAR(50) UNIQUE NOT NULL,    -- Business Key
    Category NVARCHAR(50),
    SubCategory NVARCHAR(50),
    ProductName NVARCHAR(255),

    CreateDate DATETIME,
    UpdateDate DATETIME
);
GO

CREATE TABLE dbo.Sales_Combined_NDS (
    SalesSK INT IDENTITY(1,1) PRIMARY KEY,     -- Surrogate Key

    OrderID NVARCHAR(50) UNIQUE NOT NULL,      -- Business Key

    OrderDate DATETIME,
    CustomerID NVARCHAR(50),
    ProductID NVARCHAR(50),
    Sales DECIMAL(18,2),
    Quantity INT,
    Profit DECIMAL(18,4), 
    SourceID NVARCHAR(50),

    CreateDate DATETIME,
    UpdateDate DATETIME
);
GO

-- Tìm ngày nhỏ nhất và lớn nhất trong bảng sales
SELECT
    MIN(OrderDate) AS Smallest_OrderDate,
    MAX(OrderDate) AS Largest_OrderDate
FROM
    dbo.Sales_Combined_NDS;

--Tìm các ngày trong bảng Sales
SELECT*
FROM 
	dbo.Sales_Combined_NDS
ORDER BY OrderDate
GO

CREATE PROCEDURE dbo.PopulateDimDateFromNDS
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Khai báo và lấy ngày nhỏ nhất/lớn nhất từ bảng NDS
    DECLARE @StartDate DATE;
    DECLARE @EndDate DATE;
    DECLARE @CurrentDate DATE;

    -- LƯU Ý: Thay [Ten_Database_NDS] bằng TÊN DATABASE NDS CỦA BẠN
    SELECT
        @StartDate = MIN(OrderDate),
        @EndDate = MAX(OrderDate)
    FROM
        [NDS_Seminar].dbo.Sales_Combined_NDS; 
        
    -- Xử lý trường hợp không tìm thấy dữ liệu
    IF @StartDate IS NULL OR @EndDate IS NULL
        RETURN;

    -- Khởi tạo ngày hiện tại cho vòng lặp
    SET @CurrentDate = @StartDate;

    -- 2. Bắt đầu vòng lặp để chèn từng ngày vào DimDate
    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Chèn dữ liệu vào DimDate (trong DDS_Seminar)
        INSERT INTO [DDS_Seminar].dbo.DimDate (
            DateSK,
            FullDate,
            DayNumber,
            MonthNumber,
            MonthName,
            QuarterNumber,
            YearNumber,
            DayName
        )
        SELECT
            CAST(FORMAT(@CurrentDate, 'yyyyMMdd') AS INT) AS DateSK,
            @CurrentDate AS FullDate,
            DAY(@CurrentDate) AS DayNumber,
            MONTH(@CurrentDate) AS MonthNumber,
            DATENAME(MONTH, @CurrentDate) AS MonthName,
            DATEPART(QUARTER, @CurrentDate) AS QuarterNumber,
            YEAR(@CurrentDate) AS YearNumber,
            DATENAME(WEEKDAY, @CurrentDate) AS DayName
        WHERE NOT EXISTS (
            SELECT 1 FROM [DDS_Seminar].dbo.DimDate WHERE FullDate = @CurrentDate
        );

        -- Tăng ngày lên 1
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
END
GO
EXEC dbo.PopulateDimDateFromNDS;

