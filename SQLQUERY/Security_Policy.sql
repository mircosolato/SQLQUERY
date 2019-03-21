--https://novacontext.com/sql-server-2016-dynamic-data-masking-and-row-level-security-deployment-guide/
--https://joebuschmann.com/row-level-security-in-sql-server/
--https://www.mssqltips.com/sqlservertip/2124/filtering-sql-server-columns-using-column-level-permissions/
--https://hryniewski.net/2018/02/13/row-level-security-in-ms-sql/

--CREATE DATABASE RLS

--GO

USE RLS

GO

--CREATE TABLE dbo.Customers
--(
--    CustomerId int,
--    CustomerName nvarchar(100),
--    SalesRepName nvarchar(100)
--)

--GO

----Create user defined function and define sec policy
--CREATE SCHEMA sec

--GO

--CREATE FUNCTION sec.userAccessPredicate(@UserName sysname)
--    RETURNS TABLE
--    WITH SCHEMABINDING AS
--    RETURN SELECT 1 AS accessResult
--    WHERE @UserName = USER_NAME()
--GO

--CREATE SECURITY POLICY sec.userAccessPolicy
--    ADD FILTER PREDICATE sec.userAccessPredicate(SalesRepName) ON dbo.Customers,
--    ADD BLOCK PREDICATE sec.userAccessPredicate(SalesRepName) ON dbo.Customers

--GO

--Create users without login and grant them select, insert, update, and delete access on table
--CREATE USER SalesRep1 WITHOUT LOGIN;
--CREATE USER SalesRep2 WITHOUT LOGIN;
--CREATE USER SalesRep3 WITHOUT LOGIN;
--GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO SalesRep1;
--GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO SalesRep2;
--GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Customers TO SalesRep3;

----Now insert some data, using context of each Sales Representative. If you try to insert the data without setting the context, you will get an error
--EXECUTE AS USER = 'SalesRep1'
--INSERT INTO dbo.Customers (CustomerId, CustomerName, SalesRepName) 
--VALUES (1, 'Customer1', 'SalesRep1'),
--    (2, 'Customer2', 'SalesRep1'),
--    (3, 'Customer3', 'SalesRep1'),
--    (4, 'Customer4', 'SalesRep1')
--GO

--REVERT

--EXECUTE AS USER = 'SalesRep2'

--INSERT INTO dbo.Customers (CustomerId, CustomerName, SalesRepName) 
--VALUES
--    (5, 'Customer5', 'SalesRep2'),
--    (6, 'Customer6', 'SalesRep2'),
--    (7, 'Customer7', 'SalesRep2')
--GO

--REVERT

--EXECUTE AS USER = 'SalesRep3'

--INSERT INTO dbo.Customers (CustomerId, CustomerName, SalesRepName) 
--VALUES (8, 'Customer8', 'SalesRep3')

--GO

--REVERT


EXECUTE AS USER = 'SalesRep3'
SELECT * FROM dbo.Customers 
GO
REVERT