
USE StagingDB_Seminar;

select* from dbo.Customer_Stage
select* from dbo.Product_Stage
select* from dbo.Sales_Combined_Stage

TRUNCATE TABLE dbo.Customer_Stage
TRUNCATE TABLE dbo.Product_Stage
TRUNCATE TABLE dbo.Sales_Combined_Stage


USE [MetaData_Sales]

select*
from [dbo].[ETL_Load_Control]

TRUNCATE TABLE dbo.Customer_Stage


USE NDS_Seminar;
GO

select*
from dbo.Customer_NDS

select*
from dbo.Product_NDS

select*
from dbo.Sales_Combined_NDS

TRUNCATE TABLE dbo.Customer_NDS
TRUNCATE TABLE dbo.Product_NDS
TRUNCATE TABLE dbo.Sales_Combined_NDS

USE [MetaData_DDS]
GO

select* from [dbo].[ETL_Load_Control_DDS]


USE DDS_Seminar;
GO

select* from dbo.DimCustomer
select* from dbo.DimProduct
select* from dbo.DimDate
select* from dbo.FactSales

