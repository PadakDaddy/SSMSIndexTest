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
-- CPU time = 94 ms,  elapsed time = 437 ms. logical reads 1105

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
-- CPU time = 47 ms,  elapsed time = 478 ms, logical reads 1102
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
-- CPU time = 266 ms,  elapsed time = 483 ms. logical reads 1090

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
-- CPU time = 266 ms,  elapsed time = 523 ms.logical reads 1090
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

PRINT '===SCENARIO 3-1 is DONE===';
GO

--SQL Server Execution Times:
--CPU time = 47 ms,  elapsed time = 310 ms.logical reads 1090

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
PRINT 'SCENARIO 3 is complete';
GO
-- SQL Server Execution Times:
-- CPU time = 15 ms,  elapsed time = 87 ms, logical reads 228
-- Scenario 3 result: No Index:31 ms, Clustered Index: 15 ms => Clustered Index is about 51.6% faster
DROP INDEX idxCountryCluster ON Customers;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 4====================
--Use a non-clustered index large data set with WHERE criteria (on one table with both single value and range criteria)/PostalCode
PRINT '===SCENARIO 4-1: No Index===';
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
-- CPU time = 31 ms,  elapsed time = 80 ms, logical reads 1105

PRINT '===SCENARIO 4-2: Creating Nonclustered Index on PostalCode===';
GO
-- Create new Nonclustered Index on PostalCode
CREATE NONCLUSTERED INDEX idxPostalCodeNonCluster
ON Customers(PostalCode ASC);
GO

PRINT 'Nonclustered Index Created Successfully!';
PRINT 'SCENARIO 4-2 is done';
GO

PRINT '===SCENARIO 4-3: With Nonclustered Index sorting by PostalCode===';
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
-- CPU time = 31 ms,  elapsed time = 199 ms, logical reads 1105
-- Scenario 4 result: No Index:31 ms, NonClustered Index: 31 ms =>No improvement
DROP INDEX idxPostalCodeNonCluster ON Customers;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 5====================
--Use a clustered index in a JOIN between two large data sets. Also consider what happens when using the WHERE clause in the JOIN.
PRINT '===SCENARIO 5-1: No Index===';
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Canada';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 5-1 is DONE';
GO
-- SQL Server Execution Times:
-- CPU time = 16 ms,  elapsed time = 18 ms, logical reads 61

PRINT '===SCENARIO 5-2: Creating Clustered Index on Orders.OrderDate===';
GO
-- Drop Foreign Key from Order Details table first
ALTER TABLE [Order Details]
DROP CONSTRAINT FK_Order_Details_Orders;
GO

-- Drop Primary Key constraint from Orders table
ALTER TABLE Orders
DROP CONSTRAINT PK_Orders;
GO

-- Create new Clustered Index on OrderDate
CREATE CLUSTERED INDEX idxOrderDateCluster
ON Orders(OrderDate ASC);
GO

-- Add Primary Key constraint on OrderID as Nonclustered
ALTER TABLE Orders
ADD CONSTRAINT PK_Orders PRIMARY KEY NONCLUSTERED (OrderID);
GO

-- Recreate Foreign Key in Order Details table
ALTER TABLE [Order Details]
ADD CONSTRAINT FK_Order_Details_Orders 
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);
GO

PRINT 'Clustered Index Created Successfully!';
PRINT 'SCENARIO 5-2 is done';
GO

PRINT '===SCENARIO 5-3: With Clustered Index on Orders.OrderDate===';
GO
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Canada';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 5-3 is DONE';
PRINT 'SCENARIO 5 is complete';
GO
-- SQL Server Execution Times:
-- CPU time = 0 ms,  elapsed time = 16 ms ,logical reads 23
-- Scenario 5 result: No Index:16 ms, Clustered Index:16 ms =>No improvement. It's already fast. scale is small.

DROP INDEX idxOrderDateCluster ON Orders;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 6====================
--Use a non-clustered index in a JOIN between two large data sets. Also consider what happens when using the WHERE clause in the JOIN.
PRINT '===SCENARIO 6-1: No Index===';
GO
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Canada';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 6-1 is DONE';
GO
-- Server Execution Times:
-- CPU time = 16 ms, elapsed time = 12 ms.logical reads 2601, logical reads 23

PRINT '===SCENARIO 6-2: Creating Nonclustered Index on Orders.CustomerID===';
GO

CREATE NONCLUSTERED INDEX idxCustomerIDNonCluster
ON Orders(CustomerID ASC);
GO

PRINT 'Nonclustered Index Created Successfully!';
PRINT 'SCENARIO 6-2 is done';
GO

PRINT '===SCENARIO 6-3: With Nonclustered Index on Orders.CustomerID===';
GO

CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'Canada';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 6-3 is DONE';
PRINT 'SCENARIO 6 is complete';
GO

-- SQL Server Execution Times:
-- CPU time = 0 ms,  elapsed time = 61 ms, logical reads 2780, logical reads 23 
-- Scenario 5 result: No Index:16 ms, Nonclustered Index:0 ms => Nnclustered index on CustomerID reduced CPU time but increased elapsed time
DROP INDEX idxCustomerIDNonCluster ON Orders;
PRINT 'Ready for next scenario.';
GO

--==============Scenario 7====================
--Demonstrate the effect of fragmentation. Force fragmentation to occur, then demonstrate how rebuilding the index fixes the issues.
PRINT '===SCENARIO 7-1: Create Nonclustered Index===';
GO

-- Create new Nonclustered Index on OrderDate
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate_Frag
ON Orders(OrderDate);
GO

PRINT 'Nonclustered Index Created Successfully!';
GO

-- Check Fragmentation BEFORE
PRINT '===SCENARIO 7-1: Fragmentation Status BEFORE===';
DBCC SHOWCONTIG ('Orders', 'IX_Orders_OrderDate_Frag');
GO

-- Baseline query BEFORE fragmentation
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT OrderID, OrderDate, CustomerID, EmployeeID
FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-12-31';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 7-1 BASELINE is DONE';
GO

--=== SCENARIO 7-2: Force Fragmentation ===
PRINT '===SCENARIO 7-2: Force Fragmentation (INSERT + UPDATE)===';
GO

-- Insert many rows with dates IN THE QUERY RANGE to cause page splits
-- Use DATEADD(day, -(@i % 184), '1996-12-31') to loop through the date range
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShipVia, Freight)
    VALUES ('ALFKI', 1, 
            DATEADD(day, -(@i % 184), '1996-12-31'),
            DATEADD(day, @i, '1996-12-31'), 
            1, 
            RAND()*100);
    SET @i = @i + 1;
END;
GO

-- Update rows to force fragmentation (only the new rows we inserted)
UPDATE Orders
SET Freight = Freight + (RAND() * 50)
WHERE CustomerID = 'ALFKI' AND OrderID > 11077;
GO

PRINT 'Fragmentation forced!';
GO

-- Check Fragmentation AFTER
PRINT '===SCENARIO 7-2: Fragmentation Status AFTER Updates===';
DBCC SHOWCONTIG ('Orders', 'IX_Orders_OrderDate_Frag');
GO

-- Query AFTER fragmentation
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT OrderID, OrderDate, CustomerID, EmployeeID
FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-12-31';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 7-2 WITH FRAGMENTATION is DONE';
GO

--=== SCENARIO 7-3: REBUILD Index ===
PRINT '===SCENARIO 7-3: REBUILD Index===';
GO

ALTER INDEX IX_Orders_OrderDate_Frag ON Orders REBUILD;
GO

PRINT 'Index REBUILT!';
GO

-- Check Fragmentation AFTER REBUILD
PRINT '===SCENARIO 7-3: Fragmentation Status AFTER REBUILD===';
DBCC SHOWCONTIG ('Orders', 'IX_Orders_OrderDate_Frag');
GO

-- Query AFTER REBUILD
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

SELECT OrderID, OrderDate, CustomerID, EmployeeID
FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-12-31';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

PRINT 'SCENARIO 7-3 AFTER REBUILD is DONE';
PRINT 'SCENARIO 7 is COMPLETE';
GO

-- Clean up inserted rows
DELETE FROM Orders WHERE CustomerID = 'ALFKI' AND OrderID > 11077;
GO

DROP INDEX IX_Orders_OrderDate_Frag ON Orders;
GO

PRINT 'Cleanup complete. All scenarios finished.';
GO
