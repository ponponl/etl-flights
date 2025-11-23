
CREATE DATABASE [MetaData_DDS]
GO
USE [MetaData_DDS]
GO

CREATE TABLE [dbo].[ETL_Load_Control_DDS](
	[id] INT NOT NULL PRIMARY KEY,
	[name] NVARCHAR(50) NOT NULL,
	[LSET] DATETIME NULL,
);
GO

INSERT INTO [dbo].[ETL_Load_Control_DDS] ([id], [name], [LSET])
VALUES
    (1, N'DimCustomer_DDS_Load', '1900-01-01 00:00:00.000'),
    (2, N'DimProduct_DDS_Load', '1900-01-01 00:00:00.000'),
    (3, N'DimDate_DDS_Load', '1900-01-01 00:00:00.000'),
    (5, N'FactSales_DDS_Load', '1900-01-01 00:00:00.000');
GO

UPDATE [dbo].[ETL_Load_Control_DDS]
SET 
    LSET = '2000-01-01 00:00:00.000';