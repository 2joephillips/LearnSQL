USE NWIND
GO 

PRINT 'This is my Final problems for IS 301 Class'

PRINT 'Code to remove table for problem 5'

BEGIN TRANSACTION
IF OBJECT_ID ('EXAM3_JP', 'U') IS NOT NULL 
DROP TABLE EXAM3_JP;
GO 

PRINT 'PROBLEM 1'
SELECT COUNT(CUSTOMERID)as Total
FROM CUSTOMERS; 
GO 

PRINT 'PROBLEM 2'
SELECT COMPANYNAME, AVG(FREIGHT)AS Average_Freight
FROM ORDERS JOIN CUSTOMERS ON ORDERS.CUSTOMERID = CUSTOMERS.CUSTOMERID
GROUP BY COMPANYNAME;
GO 

PRINT 'PROBLEM 3'
SELECT PRODUCTNAME
FROM PRODUCTS
WHERE PRODUCTNAME LIKE '%ai%';
GO 

PRINT 'PROBLEM 4'
SELECT COMPANYNAME, CONTACTNAME, PHONE
FROM CUSTOMERS
WHERE REGION LIKE 'WA'; 
GO 

PRINT 'PROBLEM 5'
CREATE TABLE EXAM3_JP( 
		SuggestionID	CHAR(5)			Not Null Primary Key,
		Suggestion		VARCHAR(100)	Not Null,
		SugContact		CHAR(3)			Not Null,
		SugPhone		CHAR(10),
		SugDate			DATE			Not Null,
		SugPriority		INT);	
GO 

PRINT 'PROBLEM 6'
INSERT INTO EXAM3_JP VALUES ( 'JEP1','The book for this class should really be in Oracle and SQL, and not Oracle ane Access',	
			'JEP','2056175550','08-DEC-2011',1);
GO

PRINT 'PROBLEM 7'
DELETE FROM EMPLOYEES
	WHERE LASTNAME = 'Neumann';
GO 

PRINT 'PROBLEM 8'
UPDATE CUSTOMERS 
	SET CITY = 'MUNICH'
	WHERE COMPANYNAME LIKE 'COMPANY G%';
GO

PRINT 'PROBLEM 9'
SELECT PRODUCTNAME, CATEGORYNAME, OD.UNITPRICE
FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.CUSTOMERID = ORDERS.CUSTOMERID JOIN [ORDER DETAILS] AS OD ON ORDERS.ORDERID = OD.ORDERID JOIN PRODUCTS ON OD.PRODUCTID = PRODUCTS.PRODUCTID JOIN CATEGORIES ON PRODUCTS.CATEGORYID = CATEGORIES.CATEGORYID
WHERE CUSTOMERS.REGION = 'WA';	
GO
