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


-- Subqueries and Coorelated Queries
--Example from CH. 7
-- What Vendors provide products?
SELECT V_CODE, V_NAME
FROM VENDOR
WHERE V_CODE NOT IN (SELECT V_CODE FROM PRODUCT);

-- What is the average price for all products?
SELECT P_CODE, P_PRICE
FROM PRODUCT
WHERE P_PRICE >= (SELECT AVG(P_PRICE) FROM PRODUCT)

/* RECAP Basic characteristics

	* A subquery is a query (SELECT statement) inside a query.
	* A subquery is normally expressed inside parenthese.
	* The first query in the SQL statement is known as the outer query.
	* The second query inside the SQL statement is known as the inner query.
	* The inner query is executed first. 
	* The output of an inner query is used as the input for the outer query.
	* the entire SQL statement is sometimes referred to as a nested query.

-- Additional Examples	
INSERT INTO PRODUCT		--Subquery returns list of all columns and rows in table P
	SELECT * FROM P;

UPDATE PRODUCT			--1ST Subquery returns AVG PRICE and 2nd list of VENDORS IN '615'
SET P_PRICE = (SELECT AVG(P_PRICE) FROM 
				PRODUCT)
WHERE V_CODE IN (SELECT V_CODE FROM 
				VENDOR WHERE V_AREACODE = '615')

DELETE FROM PRODUCT  -- Subquery returns list of vendors from '615'
WHERE V_CODE IN (SELECT V_CODE FROM VENDOR
				WHERE V_AREACODE = '615')									
				
*/

-- WHERE Subqueries

-- Additional uses (Find all the customers that ordered the product 'Claw Hammer')
SELECT DISTINCT CUSTOMER.CUS_CODE, CUS_LNAME, CUS_FNAME
FROM CUSTOMER JOIN INVOICE ON CUSTOMER.CUS_CODE = INVOICE.CUS_CODE 
		JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER JOIN PRODUCT
		ON LINE.P_CODE = PRODUCT.P_CODE
WHERE PRODUCT.P_CODE = (SELECT P_CODE FROM PRODUCT WHERE P_DESCRIPT ='Claw Hammer');	

-- For the above example we are restricting the PRODUCT.P_CODE with a inner query 
-- it could also be written as below.
SELECT DISTINCT CUSTOMER.CUS_CODE, CUS_LNAME, CUS_FNAME
FROM CUSTOMER JOIN INVOICE ON CUSTOMER.CUS_CODE = INVOICE.CUS_CODE 
		JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER JOIN PRODUCT
		ON LINE.P_CODE = PRODUCT.P_CODE
WHERE PRODUCT.P_DESCRIPT = 'Claw Hammer';

-- This will only work if the 'Claw Hammer' is in only one P_DESCRIPT. To work around this we will 
-- use the IN operand.



-- IN Subqueries

-- The following example will show how to compare a single attribute to a list of values.
SELECT DISTINCT CUSTOMER.CUS_CODE, CUS_LNAME, CUS_FNAME
FROM CUSTOMER JOIN INVOICE ON CUSTOMER.CUS_CODE = INVOICE.CUS_CODE 
		JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER JOIN PRODUCT
		ON LINE.P_CODE = PRODUCT.P_CODE
WHERE PRODUCT.P_CODE IN (SELECT		P_CODE FROM PRODUCT
						WHERE		P_DESCRIPT LIKE	'%hammer%'
						OR			P_DESCRIPT LIKE '%saw%');		 

--HAVING Subqueries

-- This is used to restrict a GROUP BY query by applying a conditional criteria 
-- to the grouped rows

-- Example: List all the products with a total quanity sold greater than the AVG quantity sold
SELECT P_CODE, SUM(LINE_UNITS)
FROM LINE
GROUP BY P_CODE
HAVING	SUM(LINE_UNITS) > (SELECT AVG(LINE_UNITS) FROM LINE);

-- ANY and ALL subqueries (MultiRow)

-- ALL Statment that show which products have a product cost that is greater than all individual 
-- product costs for products provided by vendors in Florida.

SELECT P_CODE, P_QOH * P_PRICE
FROM PRODUCT
WHERE P_QOH * P_PRICE > ALL (SELECT P_QOH * P_PRICE
								FROM PRODUCT 
								WHERE V_CODE IN (SELECT V_CODE
												FROM VENDOR 
												WHERE V_STATE = 'FL'));			
												
/* Explanation for above query

		* The query above is a typical example of a nested query
		* The query has one outer SELECT statment with a SELECT subquery(call it sqlA) containing
			a second SELECT subquery (call it sqlB)
		* The last SELECT subquery (sqlB) is executed first and returns a list of all vendors from Florida.
		* The first SELECT subquery (sqlA) uses the output of the SELECT subquery (sqlB). The sqlA subquery 
			returns the list of product costs for all products provided by vendors from Florida.
		* The use of the ALL operator allows you to compare a single value (P_QOH*P_PRICE) with a list 
			values returned by the first subquery sqlA using a comparsion operator other than equals.
		* For a row to appear in the result set, it has to meet the criterion P_QOH*P_PRICE > ALL, of the 
			individual values returned by the subquery sqlA. The values returned by sqlA are the list of product costs
			In fact, "greater than ALL" is equivalent to "greater than the highest product cost of the list." In the same,
			way, a condition of "less than ALL" is equivalent to "less than the lowest product cost of the list".

*/					

-- FROM Subqueries
-- What customers have purchase products '13-Q2/P2' and '23109-HB'
SELECT DISTINCT CUSTOMER.CUS_CODE, CUSTOMER.CUS_LNAME
FROM CUSTOMER, 
	(SELECT INVOICE.CUS_CODE FROM INVOICE JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER 
		WHERE P_CODE = '13-Q2/P2') CP1,
	(SELECT INVOICE.CUS_CODE FROM INVOICE JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER 
		WHERE P_CODE = '23109-HB') CP2
WHERE CUSTOMER.CUS_CODE = CP1.CUS_CODE AND CP1.CUS_CODE = CP2.CUS_CODE;	

-- Explanation of above query 
/* 
The first subquery is returning the customers that purchased the '13-Q2/P2' and the second query
	is returning the customers that purchased the '23109-HB'. The SQL is then matching the Two Virtual 
	tables with Customer and displays the row that matches all three.
*/

GO  -- This is added to a signal that they should send the current batch of Transact-SQL statements
	-- to an instance of SQL Server. Since Create View needs to be the only statment in a batch. 
	-- This GO is to prepare for the creation of VIEWS below. 
	-- For more informaiton check out http://msdn.microsoft.com/en-us/library/ms188037.aspx
	-- I will also be using it to seperate section from here on out.
	
-- Additional Syntax -- Using Views

-- Check for VIEWS CP1 AND CP2 IF exist DROP. This was added so that the could could be reran multiple times. 
IF OBJECT_ID ('CP1', 'V') IS NOT NULL 
DROP VIEW CP1;
GO 
IF OBJECT_ID ('CP2','V') IS NOT NULL
DROP VIEW CP2
GO 

CREATE VIEW CP1 AS
	SELECT	CUS_CODE FROM INVOICE JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER
	WHERE P_CODE = '13-Q2/P2'
GO

CREATE VIEW CP2 AS 
	SELECT	CUS_CODE FROM INVOICE JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER
	WHERE P_CODE = '23109-HB'	
GO 	
	
SELECT DISTINCT CUSTOMER.CUS_CODE, CUS_LNAME
FROM CUSTOMER JOIN CP1 ON CUSTOMER.CUS_CODE = CP1.CUS_CODE JOIN CP2 ON CP1.CUS_CODE = CP2.CUS_CODE
GO 

-- The following syntax while looking correct will not work and only return a blank line. 
-- the P_CODE cannot equal two different values at the same time.

SELECT CUSTOMER.CUS_CODE, CUS_LNAME
FROM CUSTOMER JOIN INVOICE ON CUSTOMER.CUS_CODE = INVOICE.CUS_CODE JOIN LINE ON INVOICE.INV_NUMBER = LINE.INV_NUMBER
WHERE P_CODE = '13-Q2/P2' AND P_CODE = '23109-HB';
GO 

-- ATTRIBUTE LIST subqueries

-- This is an inline query in the attribute list. The query must return a single value; our otherwise, an error will occur. 
-- Example: List the difference between each product's price and the average product price.
SELECT P_CODE, P_PRICE, (SELECT AVG(P_PRICE) FROM PRODUCT) AS AVGPRICE, P_PRICE - (SELECT AVG(P_PRICE) FROM PRODUCT) AS DIFF
FROM PRODUCT;

-- Example: List products, Total sales, total Employees, and the Contribution of each employee to product's sales. 
-- Since LINE and EMPLOYEE do not have a common attribute, this will need to be done inline. 
SELECT P_CODE, SUM(LINE_UNITS * LINE_PRICE) AS SALES,
	   (SELECT COUNT(*) FROM EMPLOYEE) AS ECOUNT,
	   SUM(LINE_UNITS * LINE_PRICE)/(SELECT COUNT(*) FROM EMPLOYEE) AS CONTRIB
FROM LINE
GROUP BY P_CODE;

-- Alternate Syntax using column aliases. This requires the use of a subquery in the FROM clause. 
-- At the end of the FROM subquery you must name it with an alias for it to work. 

SELECT P_CODE, SALES, ECOUNT, SALES/ECOUNT AS CONTRIB
FROM  (SELECT P_CODE, SUM(LINE_UNITS*LINE_PRICE) AS SALES,
	    (SELECT COUNT(*) FROM EMPLOYEE) AS ECOUNT
     	    FROM LINE GROUP BY P_CODE) AS TMP
GO      	    

-- CORRELATED Subqueries
-- Are subqueries that execute once for each row in the outer query. This is similar to the nested loop in programming
-- EXAMPLE: Find all product sales in which the units sold value is greater than the average units sold value for that product 
-- (verses the average for all products)
-- Items needed: 1) Compute the average-units-sold for a product, 2) Compare the average computed in Step 1 to the units sold
-- in each sale row and then select only the rows in with the number of units sold is greater.

SELECT INV_NUMBER, P_CODE, LINE_UNITS
FROM LINE LS
WHERE LS.LINE_UNITS > (SELECT	AVG(LINE_UNITS)
						FROM LINE LA
						WHERE LA.P_CODE = LS.P_CODE)
-- EXPLANATION: This is done by the INNER query running once for each P_Code in the OUTER query. When the 
-- AVG is > then LS.LINE_UNITS it is added to the output. 						
-- To show this we are will add a correlated inline subquery to show the average units sold column for each product.

SELECT INV_NUMBER, P_CODE, LINE_UNITS, (SELECT AVG(LINE_UNITS) FROM LINE LX WHERE LX.P_CODE = LS.P_CODE) AS AVGUNITS
FROM LINE LS
WHERE LS.LINE_UNITS > (SELECT	AVG(LINE_UNITS)
						FROM LINE LA
						WHERE LA.P_CODE = LS.P_CODE)
-- EXAMPLE: All customers who have placed an order lately.

SELECT CUS_CODE, CUS_LNAME, CUS_FNAME	
FROM CUSTOMER
WHERE EXISTS (SELECT CUS_CODE FROM INVOICE						
			WHERE INVOICE.CUS_CODE = CUSTOMER.CUS_CODE)
						
-- EXAMPLE: Know the vendor code and name of vedors for products having a QOH less than double the minimum quantity

SELECT V_CODE, V_NAME
FROM VENDOR
WHERE EXISTS (SELECT * 
			FROM PRODUCT
			WHERE P_QOH < P_MIN * 2
			AND VENDOR.V_CODE = PRODUCT.V_CODE)						
GO			
-- EXPLANATION: 1) The inner correlated subquery runs using the first vendor. 2) If any products match the condition (QOH < MIN*2)
-- the vendor code and name are listed in the output. 3)  The correlated subquery then runs using the second vendor, third vendor...

-- DATA AND TIME FUNCTION
-- The next examples will show the distinct values for Employees Date of Birth based on FUNCTION
-- YEAR (RETURNS A FOUR DIGIT DATE_VALUE)
SELECT DISTINCT YEAR(EMP_DOB)
FROM EMPLOYEE			
-- MONTH (RETURNS A TWO DIGIT MONTH CODE)
SELECT DISTINCT MONTH(EMP_DOB)
FROM EMPLOYEE			
-- DAY (RETURNS A TWO DIGIT NUMBER OF THE DAY)
SELECT DAY(EMP_DOB)
FROM EMPLOYEE			

-- GETDATE() (RETURNS TODAYS DATE)
SELECT EMP_DOB, GETDATE()
FROM EMPLOYEE
-- DATEADD() (Adds a number of days to a given date)
SELECT EMP_DOB, DATEADD(DAY,90,EMP_DOB) as EMP_DOB90 
FROM EMPLOYEE
-- DATEDIFF() (Returns the difference between to given dates)
SELECT DATEDIFF(DAY, EMP_DOB,GETDATE()) AS DAYSDIFFERENCE
FROM EMPLOYEE
GO

-- NUMERIC FUNCTIONS

-- ABS (Returns the absolute value of a number)
SELECT 1.95, -1.93, ABS(1.95), ABS(-1.93);

-- ROUND (Rounds a value to a specific percision)
SELECT P_CODE, P_PRICE,
		ROUND(P_PRICE,1) AS PRICE1,
		ROUND(P_PRICE,0) AS PRICE0
FROM PRODUCT

-- CEILING/FLOOR (Returns the smallest int greater than or equal to a number)/( returns the largest int equal to or less
-- than a number, respectively
SELECT P_PRICE, CEILING(P_PRICE), FLOOR(P_PRICE)
FROM PRODUCT

--STRING FUNCTIONS