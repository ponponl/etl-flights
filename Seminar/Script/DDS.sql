
CREATE DATABASE DDS_Seminar;
GO
USE DDS_Seminar;
GO

CREATE TABLE dbo.DimCustomer (
    CustomerSK INT IDENTITY(1,1) PRIMARY KEY,   

    CustomerNK NVARCHAR(50) NOT NULL UNIQUE,   

    CustomerName NVARCHAR(255),
    Segment NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    StateProvince NVARCHAR(50),

    CreateDate DATETIME NOT NULL,               
    UpdateDate DATETIME NULL                   
);
GO

CREATE TABLE dbo.DimProduct (
    ProductSK INT IDENTITY(1,1) PRIMARY KEY,

    ProductNK NVARCHAR(50) NOT NULL UNIQUE,

    Category NVARCHAR(50),
    SubCategory NVARCHAR(50),
    ProductName NVARCHAR(255),

    CreateDate DATETIME NOT NULL,
    UpdateDate DATETIME NULL
);
GO

CREATE TABLE dbo.DimDate (
    DateSK INT PRIMARY KEY,   

    FullDate DATE NOT NULL,
    DayNumber INT,
    MonthNumber INT,
    MonthName NVARCHAR(20),
    QuarterNumber INT,
    YearNumber INT,
    DayName NVARCHAR(20)
);
GO

CREATE TABLE dbo.FactSales (
    FactSalesSK INT IDENTITY(1,1) PRIMARY KEY,

    DateSK INT NOT NULL,
    CustomerSK INT NOT NULL,
    ProductSK INT NOT NULL,

    OrderNK NVARCHAR(50) NOT NULL UNIQUE,   

    Sales DECIMAL(18,2),
    Quantity INT,
    Profit DECIMAL(18,4),

    SourceID NVARCHAR(50),

    CreateDate DATETIME NOT NULL,
    UpdateDate DATETIME NULL,

    -- FK Constraints
    CONSTRAINT FK_FactSales_DimDate FOREIGN KEY (DateSK) REFERENCES dbo.DimDate(DateSK),
    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (CustomerSK) REFERENCES dbo.DimCustomer(CustomerSK),
    CONSTRAINT FK_FactSales_DimProduct FOREIGN KEY (ProductSK) REFERENCES dbo.DimProduct(ProductSK)
);
GO

ALTER TABLE dbo.DimCustomer
ADD 
    StartDate DATETIME2 NOT NULL DEFAULT '1900-01-01',
    EndDate DATETIME2 NOT NULL DEFAULT '9999-12-31',
    IsCurrent BIT NOT NULL DEFAULT 1;
GO

ALTER TABLE dbo.DimProduct
ADD 
    StartDate DATETIME2 NOT NULL DEFAULT '1900-01-01',
    EndDate DATETIME2 NOT NULL DEFAULT '9999-12-31',
    IsCurrent BIT NOT NULL DEFAULT 1;
GO



