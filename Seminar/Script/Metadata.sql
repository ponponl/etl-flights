
CREATE DATABASE [MetaData_Sales]
GO
USE [MetaData_Sales]
GO

CREATE TABLE [dbo].[ETL_Load_Control](
	[id] [int] NOT NULL PRIMARY KEY,
	[name] [nchar](50) NOT NULL,
	[LSET] [datetime] NULL, -- Last Successful Extraction Time (Dùng để lọc bản ghi)
	[CET] [datetime] NULL  -- Current Extraction Time (Dùng để ghi thời điểm bắt đầu chạy)
) ON [PRIMARY]
GO


INSERT INTO [dbo].[ETL_Load_Control] ([id], [name], [LSET])
VALUES 
    (1, N'DimCustomer_Load', '1900-01-01 00:00:00.000'),
    (2, N'DimProduct_Load', '1900-01-01 00:00:00.000'),
    (3, N'FactSales_Load', '1900-01-01 00:00:00.000'); 
GO

UPDATE ETL_Load_Control
SET 
    LSET = '2000-01-01 00:00:00.000';
