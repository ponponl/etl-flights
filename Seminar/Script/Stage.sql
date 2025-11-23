
CREATE DATABASE StagingDB_Seminar
GO
USE StagingDB_Seminar;
GO

CREATE TABLE dbo.Customer_Stage (
    CustomerID NVARCHAR(50) PRIMARY KEY, 
    CustomerName NVARCHAR(255),
    Segment NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    StateProvince NVARCHAR(50),
    
    CreateDate DATETIME DEFAULT GETDATE(),
    UpdateDate DATETIME NULL
);
GO


CREATE TABLE dbo.Product_Stage (
    ProductID NVARCHAR(50) PRIMARY KEY,
    Category NVARCHAR(50),
    SubCategory NVARCHAR(50),
    ProductName NVARCHAR(255),
    
    CreateDate DATETIME DEFAULT GETDATE(),
    UpdateDate DATETIME NULL
);
GO

CREATE TABLE dbo.Sales_Combined_Stage (
    OrderID NVARCHAR(50) PRIMARY KEY, 
    
    OrderDate DATETIME,
    CustomerID NVARCHAR(50),
    ProductID NVARCHAR(50),
    Sales DECIMAL(18, 2),
    Quantity INT,
    Profit DECIMAL(18, 4), 

    SourceID NVARCHAR(50) NOT NULL, 
    CreateDate DATETIME DEFAULT GETDATE(),
    UpdateDate DATETIME NULL
);
GO

-- 1. Thêm Khóa Ngoại cho Customer ID
ALTER TABLE dbo.Sales_Combined_Stage
ADD CONSTRAINT FK_Sales_Customer
FOREIGN KEY (CustomerID)
REFERENCES dbo.Customer_Stage (CustomerID);
GO

-- 2. Thêm Khóa Ngoại cho Product ID
ALTER TABLE dbo.Sales_Combined_Stage
ADD CONSTRAINT FK_Sales_Product
FOREIGN KEY (ProductID)
REFERENCES dbo.Product_Stage (ProductID);
GO


ALTER TABLE dbo.Sales_Combined_Stage
DROP CONSTRAINT FK_Sales_Customer;
GO

ALTER TABLE dbo.Sales_Combined_Stage
DROP CONSTRAINT FK_Sales_Product;
GO

