/* The following statements are used to learn the basics in 
UNION, MINUS, and EXCEPT. */

-- UNION query to create a set without duplicates
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER
UNION
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER_2

--	UNION ALL query to create a set with duplicates
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER
UNION ALL
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER_2

-- INTERSECT can be used to combine rows from queries, returning only the 
-- rows that appear in bothd
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER
INTERSECT
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER_2

-- Additional uses (This will find all the customer in area code '615' who have made a purchase
SELECT CUS_CODE    FROM  CUSTOMER WHERE CUS_AREACODE = '615'
INTERSECT 
SELECT DISTINCT CUS_CODE FROM INVOICE; 

-- Syntax Alternatives (no INTERSECT option)
SELECT CUS_CODE
FROM CUSTOMER
	WHERE CUS_AREACODE = '615' AND 
	CUS_CODE IN (SELECT DISTINCT CUS_CODE FROM INVOICE);
	
--MINUS is not used in SQL SERVER. The EXCEPT statement combines two rows from queries and returns only the rows that appear in the first 
--set but not in the second. Additionally, to put the last names in a~z orders. I have added the 
-- ORDER BY operator. This goes at the end, of the SQL statement.

-- CUSTOMER not found in CUSTOMER_2	
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER
EXCEPT
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER_2
ORDER BY CUS_LNAME
-- CUSTOMER_2 not found in CUSTOMER
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER_2
EXCEPT
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE
FROM CUSTOMER
ORDER BY CUS_LNAME

-- Additional uses ( this will find all the customers in area code '615' that have not made orders
SELECT  CUS_CODE FROM CUSTOMER WHERE CUS_AREACODE = '615'
EXCEPT
SELECT DISTINCT CUS_CODE FROM INVOICE; 

-- SYNTAX Alternatives
SELECT CUS_CODE FROM CUSTOMER 
	WHERE CUS_AREACODE = '615' AND 
	CUS_CODE NOT IN (SELECT CUS_CODE FROM  INVOICE)
	
/* The next section we will be covering the types of joins that can be completed
CROSS JOIN, INNER JOIN (OLD - STYLE, NATURAL JOIN, JOIN USING, JOIN ON), OUTER JOIN (LEFT, RIGHT, FULL)
*/	

-- CROSS JOIN
SELECT * FROM INVOICE CROSS JOIN LINE; -- (CARTESIAN PRODUCT) 
-- ( 8 INVOICE ROWS AND 18 LINE ROWS, TOTAL OF 144 ROWS)

--Additional uses (yield only secified attributes
SELECT INVOICE.INV_NUMBER, CUS_CODE, INV_DATE, P_CODE
FROM INVOICE CROSS JOIN LINE;

--Alternative Syntax
SELECT INVOICE.INV_NUMBER, CUS_CODE, INV_DATE, P_CODE
FROM INVOICE, LINE

-- INNTER JOINS

-- NATURAL JOIN (The syntax for NATURAL JOIN is not possible in SQL server) 
-- The main issue with this is that you are letting the SQL engine quess were the join should happen. 
-- EXAMPLE TWO TABLES (NATURAL JOIN projects the join at CUS_CODE)
/* 
   SELECT CUS_CODE, CUS_LNAME, INV_NUMBER, INV_DATE
   FROM DBO.CUSTOMER NATURAL JOIN DBO.INVOICE 
*/   
-- EXAMPLE THREE TABLES (NATURAL JOIN projects join at CUS_CODE AND INV_NUMBER)
/*   
     SELECT INV_NUMBER, P_CODE, P_DESCRIPT, LINE_UNITS, LINE_PRICE
	 FROM INVOICE NATURAL JOIN LINE  NATURAL JOIN PRODUCT	 
*/

-- JOIN USING clause (This syntax is not able to be used on SQL Server)
-- This join again does not use table qualifers, and is only used in Oracle
-- EXAMPLE
/*
	SELECT INV_NUMBER, P_CODE, P_DESCRIPT, LINE_UNITS, LINE_PRICE 
	FROM INVOICE JOIN LINE USING(INV_NUMBER) JOIN PRODUCT USING(P_CODE);
*/

--JOIN ON clause 
-- This join uses table qualifers. To do this there is typically an equality comparison expression
-- of two columns. This enables for different table names to be used. In all this give the coder more
-- control on how a query will run. Versus the lack o control in NATURAL JOIN OR JOIN USING.

SELECT INVOICE.INV_NUMBER, PRODUCT.P_CODE, P_DESCRIPT, LINE_UNITS, LINE_PRICE
FROM INVOICE JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER
		JOIN	PRODUCT ON LINE.P_CODE = PRODUCT.P_CODE;	

 
-- Additional uses ( create list of managers from a single table)
-- To do this we will also need to use aliases E = EMPLOYEE AND M = MANAGER

Select E.EMP_MGR, M.EMP_LNAME, E.EMP_NUM, E.EMP_LNAME
FROM EMP E join EMP M ON E.EMP_MGR = M.EMP_NUM
ORDER BY E.EMP_MGR;

-- OUTER JOINS 

-- An outer join returns only the rows matching the join condition, but also the rows with unmatched values
-- Understanding the syntax 1st table in the from is the LEFT, and the 2nd table is the RIGHT.
--		When more than two tables are joined, example T1, T2, and T3, Left is T1 and RIGHT is T2. 
--		When they JOIN they are now the LEFT and T3 is the RIGHT. 

-- LEFT JOIN (In this case with LEFT being Vendor, V_CODE and V_NAME will not have nulls, but 
-- P_CODE will have nulls) ORDER BY P_CODE/V_NAME to make example easier to see
SELECT P_CODE, VENDOR.V_CODE, V_NAME
FROM VENDOR LEFT JOIN PRODUCT ON VENDOR.V_CODE = PRODUCT.V_CODE
ORDER BY P_CODE

-- RIGHT JOIN (In this case with RIGHT being PRODUCT, P_CODE will not have nulls, but 
-- V_CODE AND V_NAME will have nulls)
SELECT P_CODE, VENDOR.V_CODE, V_NAME
FROM VENDOR RIGHT JOIN PRODUCT ON VENDOR.V_CODE = PRODUCT.V_CODE
ORDER BY V_NAME

-- FULL JOIN (In this case not only the rows mtching the JOIN condition are returned but also all 
-- of the rows with unmatched values in either side table) LEFT AND RIGHT Do not matter.

SELECT P_CODE, VENDOR.V_AREACODE, V_NAME
FROM VENDOR FULL JOIN PRODUCT ON VENDOR.V_CODE = PRODUCT.V_CODE
ORDER BY P_CODE;


