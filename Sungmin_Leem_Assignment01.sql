/*
==================================================
A01 - INDEXES ASSIGNMENT
==================================================
Student Name: Sungmin Leem
Date: 2026-01-28
Database: Northwind
Data: Add40kCustomers.sql
==================================================
*/

USE Northwind;
GO

-- check data
SELECT COUNT(*) as TotalCustomers FROM Customers;
GO
PRINT 'Ready to begin Scenarios.';
GO
--===========Senario 1=============================
--SCENARIO 1: Use a clustered index on a large data set to retrieve sorted results (on one table)/sorting by ContactName
PRINT '===SCENARIO 1-1: NO Index===';

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, ContactName, Country
FROM Customers
ORDER BY ContactName;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 1-1 is DONE';
GO
-- SQL Server Execution Times:
-- CPU time = 94 ms,  elapsed time = 437 ms.

PRINT '===SCENARIO 1-2: Creating Clustered Index on ContactName===';
GO
-- Drop Foreign Key from Orders table
ALTER TABLE Orders
DROP CONSTRAINT FK_Orders_Customers;
GO

-- Drop Foreign Key from CustomerCustomerDemo table
ALTER TABLE CustomerCustomerDemo
DROP CONSTRAINT FK_CustomerCustomerDemo_Customers;
GO

-- Drop Primary Key constraint from Customers table
ALTER TABLE Customers
DROP CONSTRAINT PK_Customers;
GO

-- Create new Clustered Index on ContactName
CREATE CLUSTERED INDEX idxContactNameCluster
ON Customers(ContactName ASC);
GO

-- Add Primary Key constraint on CustomerID as Nonclustered
ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY NONCLUSTERED (CustomerID);
GO

-- Recreate Foreign Key in Orders table
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
GO

-- Recreate Foreign Key in CustomerCustomerDemo table
ALTER TABLE CustomerCustomerDemo
ADD CONSTRAINT FK_CustomerCustomerDemo_Customers 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
GO

PRINT 'Clustered Index Created Successfully!';
PRINT 'SCENARIO 1-2 is DONE';
GO

PRINT '===SCENARIO 1-3: With Clustered Index sorting by ContactName===';
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, ContactName, Country
FROM Customers
ORDER BY ContactName;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 1-3 is DONE';
PRINT 'SCENARIO 1 is complete';
GO
-- SQL Server Execution Times:
-- CPU time = 47 ms,  elapsed time = 478 ms.
-- Scenario 1 result: No Index: 63 ms, With Index: 47 ms => With Index is about 25.4% faster
DROP INDEX idxContactNameCluster ON Customers;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 2====================
--Use a non-clustered index on a large data set to retrieve sorted results (on one table)//sorting by CompanyName
PRINT '===SCENARIO 2-1: No Index===';
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, ContactName, Country
FROM Customers
ORDER BY CompanyName;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 2-1 is done';
GO
-- SQL Server Execution Times:
-- CPU time = 266 ms,  elapsed time = 483 ms.

PRINT '===SCENARIO 2-2: Creating Nonclustered Index on CompanyName===';
GO
-- Create new Nonclustered Index on CompanyName
CREATE NONCLUSTERED INDEX idxCompanyNameNonCluster
ON Customers(CompanyName ASC);
GO

PRINT 'Nonclustered Index Created Successfully!';
PRINT 'SCENARIO 2-2 is done';
GO

PRINT '===SCENARIO 2-3: With Nonlustered Index sorting by CompanyName===';
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, ContactName, Country
FROM Customers
ORDER BY CompanyName;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
PRINT 'SCENARIO 2-3 is DONE';
PRINT 'SCENARIO 2 is complete';
GO
-- SQL Server Execution Times:
-- CPU time = 266 ms,  elapsed time = 523 ms.
-- Scenario 2 result: No Index: 266 ms, With Nonclustered Index: 266 ms => Nonclustered Index less effective for ORDER BY
DROP INDEX idxCompanyNameNonCluster ON Customers;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 3====================
--Use a clustered index on a large data set with WHERE criteria (on one table with both single value and range criteria)//Canada
PRINT '===SCENARIO 3-1: No Index===';
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, Country, City
FROM Customers
WHERE Country = 'Canada';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 3-1 is DONE';
GO

PRINT '===SCENARIO 3-2: Creating Clustered Index on Country===';
GO
-- Drop Foreign Key from Orders table first
ALTER TABLE Orders
DROP CONSTRAINT FK_Orders_Customers;
GO

-- Drop Foreign Key from CustomerCustomerDemo table
ALTER TABLE CustomerCustomerDemo
DROP CONSTRAINT FK_CustomerCustomerDemo_Customers;
GO

-- Drop Primary Key constraint from Customers table
ALTER TABLE Customers
DROP CONSTRAINT PK_Customers;
GO

-- Create new Clustered Index on Country
CREATE CLUSTERED INDEX idxCountryCluster
ON Customers(Country ASC);
GO

-- Add Primary Key constraint on CustomerID as Nonclustered
ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY NONCLUSTERED (CustomerID);
GO

-- Recreate Foreign Key in Orders table
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
GO

-- Recreate Foreign Key in CustomerCustomerDemo table
ALTER TABLE CustomerCustomerDemo
ADD CONSTRAINT FK_CustomerCustomerDemo_Customers 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
GO

PRINT 'Clustered Index Created Successfully!';
PRINT 'SCENARIO 3-2 is DONE';
GO
-- SQL Server Execution Times:
-- CPU time = 31 ms,  elapsed time = 170 ms.

PRINT '===SCENARIO 3-3: Clustered Index WHERE condition: Country,Canada ===';
GO
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, Country, City
FROM Customers
WHERE Country = 'Canada';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 3-3 is DONE';
PRINT 'SCENARIO 2 is complete';
GO
-- SQL Server Execution Times:
-- CPU time = 15 ms,  elapsed time = 87 ms.
-- Scenario 3 result: No Index:31 ms, Clustered Index: 15 ms => Clustered Index is about 51.6% faster
DROP INDEX idxCountryCluster ON Customers;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 4====================
--Use a non-clustered index large data set with WHERE criteria (on one table with both single value and range criteria)/PostalCode
PRINT 'SCENARIO 4-1: No Index';
GO
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, PostalCode, City
FROM Customers
WHERE PostalCode BETWEEN '10000' AND '20000';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 4-1 is DONE';
GO
-- SQL Server Execution Times:
-- CPU time = 31 ms,  elapsed time = 80 ms.

PRINT '===SCENARIO 4-2: Creating Nonclustered Index on PostalCode===';
GO
-- Create new Nonclustered Index on PostalCode
CREATE NONCLUSTERED INDEX idxPostalCodeNonCluster
ON Customers(PostalCode ASC);
GO

PRINT 'Nonclustered Index Created Successfully!';
PRINT 'SCENARIO 4-2 is done';
GO

PRINT '===SCENARIO 4-3: With Nonlustered Index sorting by PostalCode===';
GO
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT CustomerID, CompanyName, PostalCode, City
FROM Customers
WHERE PostalCode BETWEEN '10000' AND '20000';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 4-3 is DONE';
PRINT 'SCENARIO 4 is complete';
GO
-- SQL Server Execution Times:
-- CPU time = 31 ms,  elapsed time = 199 ms.
-- Scenario 4 result: No Index:31 ms, NonClustered Index: 31 ms =>No improvement
DROP NONCLUSTERED INDEX idxPostalCodeNonCluster ON Customers;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 5====================
--UUse a clustered index in a JOIN between two large data sets. Also consider what happens when using the WHERE clause in the JOIN.
PRINT 'SCENARIO 5-1: No Index';
GO





--==============Scenario 6====================
--Use a non-clustered index in a JOIN between two large data sets. Also consider what happens when using the WHERE clause in the JOIN.
PRINT 'SCENARIO 6-1: No Index';
GO