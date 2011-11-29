USE CH08_SALECO
GO 

BEGIN TRANSACTION
IF OBJECT_ID ('LINE', 'U') IS NOT NULL 
DROP TABLE LINE;
GO 
IF OBJECT_ID ('INVOICE', 'U') IS NOT NULL 
DROP TABLE INVOICE;
GO 
IF OBJECT_ID ('CUSTOMER', 'U') IS NOT NULL 
DROP TABLE CUSTOMER;
GO 
IF OBJECT_ID ('CUSTOMER_2', 'U') IS NOT NULL 
DROP TABLE CUSTOMER_2;
GO 
IF OBJECT_ID ('PRODUCT', 'U') IS NOT NULL 
DROP TABLE PRODUCT;
GO
IF OBJECT_ID ('VENDOR', 'U') IS NOT NULL 
DROP TABLE VENDOR;
GO 
IF OBJECT_ID ('EMPLOYEE', 'U') IS NOT NULL 
DROP TABLE EMPLOYEE;
GO 
IF OBJECT_ID ('EMP', 'U') IS NOT NULL 
DROP TABLE EMP;
GO 
IF OBJECT_ID ('P', 'U') IS NOT NULL 
DROP TABLE P;
GO 
IF OBJECT_ID ('V', 'U') IS NOT NULL 
DROP TABLE V;
GO 
-- ADDING Data to tables
COMMIT

BEGIN TRANSACTION
-- Add data for queries
CREATE TABLE V ( 
V_CODE 		INTEGER PRIMARY KEY, 
V_NAME 		VARCHAR(35) NOT NULL, 
V_CONTACT 	VARCHAR(15) NOT NULL, 
V_AREACODE 	CHAR(3) NOT NULL, 
V_PHONE 	CHAR(8) NOT NULL, 
V_STATE 	CHAR(2) NOT NULL, 
V_ORDER 	CHAR(1) NOT NULL);


CREATE TABLE P (
P_CODE 		VARCHAR(10) PRIMARY KEY,
P_DESCRIPT 	VARCHAR(35) NOT NULL,
P_INDATE 	DATETIME NOT NULL,
P_QOH 	        INTEGER NOT NULL,
P_MIN 		INTEGER NOT NULL,
P_PRICE 	NUMERIC(8,2) NOT NULL,
P_DISCOUNT 	NUMERIC(4,2) NOT NULL,
V_CODE 		INTEGER,
P_MIN_ORDER	INTEGER,
P_REORDER	INTEGER);


CREATE TABLE VENDOR ( 
V_CODE 		INTEGER, 
V_NAME 		VARCHAR(35) NOT NULL, 
V_CONTACT 	VARCHAR(15) NOT NULL, 
V_AREACODE 	CHAR(3) NOT NULL, 
V_PHONE 	CHAR(8) NOT NULL, 
V_STATE 	CHAR(2) NOT NULL, 
V_ORDER 	CHAR(1) NOT NULL, 
PRIMARY KEY (V_CODE));


CREATE TABLE PRODUCT (
P_CODE 		VARCHAR(10) CONSTRAINT PRODUCT_P_CODE_PK PRIMARY KEY,
P_DESCRIPT 	VARCHAR(35) NOT NULL,
P_INDATE 	DATETIME NOT NULL,
P_QOH   	INTEGER NOT NULL,
P_MIN 		INTEGER NOT NULL,
P_PRICE 	NUMERIC(8,2) NOT NULL,
P_DISCOUNT 	NUMERIC(4,2) NOT NULL,
V_CODE 		INTEGER,
P_MIN_ORDER	INTEGER,
P_REORDER	INTEGER,
CONSTRAINT PRODUCT_V_CODE_FK
FOREIGN KEY (V_CODE) REFERENCES VENDOR);

CREATE TABLE CUSTOMER (
CUS_CODE	INTEGER PRIMARY KEY,
CUS_LNAME	VARCHAR(15) NOT NULL,
CUS_FNAME	VARCHAR(15) NOT NULL,
CUS_INITIAL	CHAR(1),
CUS_AREACODE 	CHAR(3) DEFAULT '615' NOT NULL CHECK(CUS_AREACODE IN ('615','713','931')),
CUS_PHONE	CHAR(8) NOT NULL,
CUS_BALANCE	NUMERIC(9,2) DEFAULT 0.00,
CONSTRAINT CUS_UI1 UNIQUE(CUS_LNAME,CUS_FNAME));

CREATE TABLE CUSTOMER_2 (
CUS_CODE	INTEGER PRIMARY KEY,
CUS_LNAME	VARCHAR(15) NOT NULL,
CUS_FNAME	VARCHAR(15) NOT NULL,
CUS_INITIAL	CHAR(1),
CUS_AREACODE 	CHAR(3),
CUS_PHONE	CHAR(8));


CREATE TABLE INVOICE (
INV_NUMBER     	INTEGER PRIMARY KEY,
CUS_CODE	INTEGER NOT NULL REFERENCES CUSTOMER(CUS_CODE),
INV_DATE  	DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
CONSTRAINT INV_CK1 CHECK (INV_DATE > '01-JAN-2010'));

CREATE TABLE LINE (
INV_NUMBER 	INTEGER NOT NULL,
LINE_NUMBER	NUMERIC(2,0) NOT NULL,
P_CODE		VARCHAR(10) NOT NULL,
LINE_UNITS	NUMERIC(9,2) DEFAULT 0.00 NOT NULL,
LINE_PRICE	NUMERIC(9,2) DEFAULT 0.00 NOT NULL,
PRIMARY KEY (INV_NUMBER,LINE_NUMBER),
FOREIGN KEY (INV_NUMBER) REFERENCES INVOICE ON DELETE CASCADE,
FOREIGN KEY (P_CODE) REFERENCES PRODUCT(P_CODE),
CONSTRAINT LINE_UI1 UNIQUE(INV_NUMBER, P_CODE));


CREATE TABLE EMPLOYEE (
EMP_NUM		INTEGER	PRIMARY KEY,
EMP_TITLE	CHAR(10),	
EMP_LNAME	VARCHAR(15) NOT NULL,
EMP_FNAME	VARCHAR(15) NOT NULL,
EMP_INITIAL	CHAR(1),
EMP_DOB		DATETIME,
EMP_HIRE_DATE	DATETIME,
EMP_YEARS	INTEGER,
EMP_AREACODE 	CHAR(3),
EMP_PHONE	CHAR(8));


CREATE TABLE EMP (
EMP_NUM		INTEGER	PRIMARY KEY,
EMP_TITLE	CHAR(10),	
EMP_LNAME	VARCHAR(15) NOT NULL,
EMP_FNAME	VARCHAR(15) NOT NULL,
EMP_INITIAL	CHAR(1),
EMP_DOB		DATETIME,
EMP_HIRE_DATE	DATETIME,
EMP_AREACODE 	CHAR(3),
EMP_PHONE	CHAR(8),
EMP_MGR		INTEGER);


/* V rows						*/
INSERT INTO V VALUES(21225,'Bryson, Inc.'    ,'Smithson','615','223-3234','TN','Y');
INSERT INTO V VALUES(21226,'SuperLoo, Inc.'  ,'Flushing','904','215-8995','FL','N');
INSERT INTO V VALUES(21231,'D&E Supply'      ,'Singh'   ,'615','228-3245','TN','Y');
INSERT INTO V VALUES(21344,'Gomez Bros.'     ,'Ortega'  ,'615','889-2546','KY','N');
INSERT INTO V VALUES(22567,'Dome Supply'     ,'Smith'   ,'901','678-1419','GA','N');
INSERT INTO V VALUES(23119,'Randsets Ltd.'   ,'Anderson','901','678-3998','GA','Y');
INSERT INTO V VALUES(24004,'Brackman Bros.'  ,'Browning','615','228-1410','TN','N');
INSERT INTO V VALUES(24288,'ORDVA, Inc.'     ,'Hakford' ,'615','898-1234','TN','Y');
INSERT INTO V VALUES(25443,'B&K, Inc.'       ,'Smith'   ,'904','227-0093','FL','N');
INSERT INTO V VALUES(25501,'Damal Supplies'  ,'Smythe'  ,'615','890-3529','TN','N');
INSERT INTO V VALUES(25595,'Rubicon Systems' ,'Orton'   ,'904','456-0092','FL','Y');

/* P rows						*/
INSERT INTO P VALUES('11QER/31','Power painter, 15 psi., 3-nozzle'     ,'03-NOV-2009',  8,  5,109.99,0.00,25595, 25,0);
INSERT INTO P VALUES('13-Q2/P2','7.25-in. pwr. saw blade'              ,'13-DEC-2009', 32, 15, 14.99,0.05,21344, 50,0);
INSERT INTO P VALUES('14-Q1/L3','9.00-in. pwr. saw blade'              ,'13-NOV-2009', 18, 12, 17.49,0.00,21344, 50,0);
INSERT INTO P VALUES('1546-QQ2','Hrd. cloth, 1/4-in., 2x50'            ,'15-JAN-2010', 15,  8, 39.95,0.00,23119, 35,0);
INSERT INTO P VALUES('1558-QW1','Hrd. cloth, 1/2-in., 3x50'            ,'15-JAN-2010', 23,  5, 43.99,0.00,23119, 25,0);
INSERT INTO P VALUES('2232/QTY','B&D jigsaw, 12-in. blade'             ,'30-DEC-2009',  8,  5,109.92,0.05,24288, 15,0);
INSERT INTO P VALUES('2232/QWE','B&D jigsaw, 8-in. blade'              ,'24-DEC-2009',  6,  5, 99.87,0.05,24288, 15,0);
INSERT INTO P VALUES('2238/QPD','B&D cordless drill, 1/2-in.'          ,'20-JAN-2010', 12,  5, 38.95,0.05,25595, 12,0);
INSERT INTO P VALUES('23109-HB','Claw hammer'                          ,'20-JAN-2010', 23, 10,  9.95,0.10,21225, 25,0);
INSERT INTO P VALUES('23114-AA','Sledge hammer, 12 lb.'                ,'02-JAN-2010',  8,  5, 14.40,0.05,NULL , 12,0);
INSERT INTO P VALUES('54778-2T','Rat-tail file, 1/8-in. fine'          ,'15-DEC-2009', 43, 20,  4.99,0.00,21344, 25,0);
INSERT INTO P VALUES('89-WRE-Q','Hicut chain saw, 16 in.'              ,'07-FEB-2010', 11,  5,256.99,0.05,24288, 10,0);
INSERT INTO P VALUES('PVC23DRT','PVC pipe, 3.5-in., 8-ft'              ,'20-FEB-2010',188, 75,  5.87,0.00,NULL , 50,0);
INSERT INTO P VALUES('SM-18277','1.25-in. metal screw, 25'             ,'01-MAR-2010',172, 75,  6.99,0.00,21225, 50,0);
INSERT INTO P VALUES('SW-23116','2.5-in. wd. screw, 50'                ,'24-FEB-2010',237,100,  8.45,0.00,21231,100,0);
INSERT INTO P VALUES('WR3/TT3' ,'Steel matting, 4''x8''x1/6", .5" mesh','17-JAN-2010', 18,  5,119.95,0.10,25595, 10,0);


/* VENDOR rows						*/
INSERT INTO VENDOR SELECT * FROM V;

/* PRODUCT rows						*/
INSERT INTO PRODUCT SELECT * FROM P;

/* CUSTOMER rows					*/
INSERT INTO CUSTOMER VALUES(10010,'Ramas'   ,'Alfred','A' ,'615','844-2573',0);
INSERT INTO CUSTOMER VALUES(10011,'Dunne'   ,'Leona' ,'K' ,'713','894-1238',0);
INSERT INTO CUSTOMER VALUES(10012,'Smith'   ,'Kathy' ,'W' ,'615','894-2285',345.86);
INSERT INTO CUSTOMER VALUES(10013,'Olowski' ,'Paul'  ,'F' ,'615','894-2180',536.75);
INSERT INTO CUSTOMER VALUES(10014,'Orlando' ,'Myron' ,NULL,'615','222-1672',0);
INSERT INTO CUSTOMER VALUES(10015,'O''Brian','Amy'   ,'B' ,'713','442-3381',0);
INSERT INTO CUSTOMER VALUES(10016,'Brown'   ,'James' ,'G' ,'615','297-1228',221.19);
INSERT INTO CUSTOMER VALUES(10017,'Williams','George',NULL,'615','290-2556',768.93);
INSERT INTO CUSTOMER VALUES(10018,'Farriss' ,'Anne'  ,'G' ,'713','382-7185',216.55);
INSERT INTO CUSTOMER VALUES(10019,'Smith'   ,'Olette','K' ,'615','297-3809',0);

/* CUSTOMER_2 rows					*/
INSERT INTO CUSTOMER_2 VALUES(345,'Terrell','Justine','H','615','322-9870');
INSERT INTO CUSTOMER_2 VALUES(347,'Olowski','Paul','F',615,'894-2180');
INSERT INTO CUSTOMER_2 VALUES(351,'Hernandez','Carlos','J','723','123-7654');
INSERT INTO CUSTOMER_2 VALUES(352,'McDowell','George',NULL,'723','123-7768');
INSERT INTO CUSTOMER_2 VALUES(365,'Tirpin','Khaleed','G','723','123-9876');
INSERT INTO CUSTOMER_2 VALUES(368,'Lewis','Marie','J','734','332-1789');
INSERT INTO CUSTOMER_2 VALUES(369,'Dunne','Leona','K','713','894-1238');


/* INVOICE rows						*/
INSERT INTO INVOICE VALUES(1001,10014,'16-JAN-2010');
INSERT INTO INVOICE VALUES(1002,10011,'16-JAN-2010');
INSERT INTO INVOICE VALUES(1003,10012,'16-JAN-2010');
INSERT INTO INVOICE VALUES(1004,10011,'17-JAN-2010');
INSERT INTO INVOICE VALUES(1005,10018,'17-JAN-2010');
INSERT INTO INVOICE VALUES(1006,10014,'17-JAN-2010');
INSERT INTO INVOICE VALUES(1007,10015,'17-JAN-2010');
INSERT INTO INVOICE VALUES(1008,10011,'17-JAN-2010');

/* LINE rows						*/
INSERT INTO LINE VALUES(1001,1,'13-Q2/P2',1,14.99);
INSERT INTO LINE VALUES(1001,2,'23109-HB',1,9.95);
INSERT INTO LINE VALUES(1002,1,'54778-2T',2,4.99);
INSERT INTO LINE VALUES(1003,1,'2238/QPD',1,38.95);
INSERT INTO LINE VALUES(1003,2,'1546-QQ2',1,39.95);
INSERT INTO LINE VALUES(1003,3,'13-Q2/P2',5,14.99);
INSERT INTO LINE VALUES(1004,1,'54778-2T',3,4.99);
INSERT INTO LINE VALUES(1004,2,'23109-HB',2,9.95);
INSERT INTO LINE VALUES(1005,1,'PVC23DRT',12,5.87);
INSERT INTO LINE VALUES(1006,1,'SM-18277',3,6.99);
INSERT INTO LINE VALUES(1006,2,'2232/QTY',1,109.92);
INSERT INTO LINE VALUES(1006,3,'23109-HB',1,9.95);
INSERT INTO LINE VALUES(1006,4,'89-WRE-Q',1,256.99);
INSERT INTO LINE VALUES(1007,1,'13-Q2/P2',2,14.99);
INSERT INTO LINE VALUES(1007,2,'54778-2T',1,4.99);
INSERT INTO LINE VALUES(1008,1,'PVC23DRT',5,5.87);
INSERT INTO LINE VALUES(1008,2,'WR3/TT3',3,119.95);
INSERT INTO LINE VALUES(1008,3,'23109-HB',1,9.95);

/* EMP rows						*/
INSERT INTO EMP VALUES(100,'Mr.' ,'Kolmycz'   ,'George' ,'D' ,'15-JUN-1942','15-MAR-1985','615','324-5456',NULL);
INSERT INTO EMP VALUES(101,'Ms.' ,'Lewis'     ,'Rhonda' ,'G' ,'19-MAR-1965','25-APR-1986','615','324-4472',100);
INSERT INTO EMP VALUES(102,'Mr.' ,'Vandam'    ,'Rhett'  ,NULL,'14-NOV-1958','20-DEC-1990','901','675-8993',100);
INSERT INTO EMP VALUES(103,'Ms.' ,'Jones'     ,'Anne'   ,'M' ,'16-OCT-1974','28-AUG-1994','615','898-3456',100);
INSERT INTO EMP VALUES(104,'Mr.' ,'Lange'     ,'John'   ,'P' ,'08-NOV-1971','20-OCT-1994','901','504-4430',105);
INSERT INTO EMP VALUES(105,'Mr.' ,'Williams'  ,'Robert' ,'D' ,'14-MAR-1975','08-NOV-1998','615','890-3220',NULL);
INSERT INTO EMP VALUES(106,'Mrs.','Smith'     ,'Jeanine','K' ,'12-FEB-1968','05-JAN-1989','615','324-7883',105);
INSERT INTO EMP VALUES(107,'Mr.' ,'Diante'    ,'Jorge'  ,'D' ,'21-AUG-1974','02-JUL-1994','615','890-4567',105);
INSERT INTO EMP VALUES(108,'Mr.' ,'Wiesenbach','Paul'   ,'R' ,'14-FEB-1966','18-NOV-1992','615','897-4358',NULL);
INSERT INTO EMP VALUES(109,'Mr.' ,'Smith'     ,'George' ,'K' ,'18-JUN-1961','14-APR-1989','901','504-3339',108);
INSERT INTO EMP VALUES(110,'Mrs.','Genkazi'   ,'Leighla','W' ,'19-MAY-1970','01-DEC-1990','901','569-0093',108);
INSERT INTO EMP VALUES(111,'Mr.' ,'Washington','Rupert' ,'E' ,'03-JAN-1966','21-JUN-1993','615','890-4925',105);
INSERT INTO EMP VALUES(112,'Mr.' ,'Johnson'   ,'Edward' ,'E' ,'14-MAY-1961','01-DEC-1983','615','898-4387',100);
INSERT INTO EMP VALUES(113,'Ms.' ,'Smythe'    ,'Melanie','P' ,'15-SEP-1970','11-MAY-1999','615','324-9006',105);
INSERT INTO EMP VALUES(114,'Ms.' ,'Brandon'   ,'Marie'  ,'G' ,'02-NOV-1956','15-NOV-1979','901','882-0845',108);
INSERT INTO EMP VALUES(115,'Mrs.','Saranda'   ,'Hermine','R' ,'25-JUL-1972','23-APR-1993','615','324-5505',105);
INSERT INTO EMP VALUES(116,'Mr.' ,'Smith'     ,'George' ,'A' ,'08-NOV-1965','10-DEC-1988','615','890-2984',108);

/* EMPLOYEE rows					*/
INSERT INTO EMPLOYEE VALUES(100,'Mr.' ,'Kolmycz'   ,'George' ,'D' ,'15-JUN-1942','15-MAR-1985',18,'615','324-5456');
INSERT INTO EMPLOYEE VALUES(101,'Ms.' ,'Lewis'     ,'Rhonda' ,'G' ,'19-MAR-1965','25-APR-1986',16,'615','324-4472');
INSERT INTO EMPLOYEE VALUES(102,'Mr.' ,'Vandam'    ,'Rhett'  ,NULL,'14-NOV-1958','20-DEC-1990',12,'901','675-8993');
INSERT INTO EMPLOYEE VALUES(103,'Ms.' ,'Jones'     ,'Anne'   ,'M' ,'16-OCT-1974','28-AUG-1994', 8,'615','898-3456');
INSERT INTO EMPLOYEE VALUES(104,'Mr.' ,'Lange'     ,'John'   ,'P' ,'08-NOV-1971','20-OCT-1994', 8,'901','504-4430');
INSERT INTO EMPLOYEE VALUES(105,'Mr.' ,'Williams'  ,'Robert' ,'D' ,'14-MAR-1975','08-NOV-1998', 4,'615','890-3220');
INSERT INTO EMPLOYEE VALUES(106,'Mrs.','Smith'     ,'Jeanine','K' ,'12-FEB-1968','05-JAN-1989',14,'615','324-7883');
INSERT INTO EMPLOYEE VALUES(107,'Mr.' ,'Diante'    ,'Jorge'  ,'D' ,'21-AUG-1974','02-JUL-1994', 8,'615','890-4567');
INSERT INTO EMPLOYEE VALUES(108,'Mr.' ,'Wiesenbach','Paul'   ,'R' ,'14-FEB-1966','18-NOV-1992',10,'615','897-4358');
INSERT INTO EMPLOYEE VALUES(109,'Mr.' ,'Smith'     ,'George' ,'K' ,'18-JUN-1961','14-APR-1989',13,'901','504-3339');
INSERT INTO EMPLOYEE VALUES(110,'Mrs.','Genkazi'   ,'Leighla','W' ,'19-MAY-1970','01-DEC-1990',12,'901','569-0093');
INSERT INTO EMPLOYEE VALUES(111,'Mr.' ,'Washington','Rupert' ,'E' ,'03-JAN-1966','21-JUN-1993', 9,'615','890-4925');
INSERT INTO EMPLOYEE VALUES(112,'Mr.' ,'Johnson'   ,'Edward' ,'E' ,'14-MAY-1961','01-DEC-1983',19,'615','898-4387');
INSERT INTO EMPLOYEE VALUES(113,'Ms.' ,'Smythe'    ,'Melanie','P' ,'15-SEP-1970','11-MAY-1999', 3,'615','324-9006');
INSERT INTO EMPLOYEE VALUES(114,'Ms.' ,'Brandon'   ,'Marie'  ,'G' ,'02-NOV-1956','15-NOV-1979',23,'901','882-0845');
INSERT INTO EMPLOYEE VALUES(115,'Mrs.','Saranda'   ,'Hermine','R' ,'25-JUL-1972','23-APR-1993', 9,'615','324-5505');
INSERT INTO EMPLOYEE VALUES(116,'Mr.' ,'Smith'     ,'George' ,'A' ,'08-NOV-1965','10-DEC-1988',14,'615','890-2984');

COMMIT;
GO


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
GO 

--STRING FUNCTIONS

-- Concatenation (takes two data values and turns into single string)
SELECT EMP_LNAME + ', ' + EMP_FNAME
FROM EMPLOYEE;

--UPPER/LOWER (Returns all as Upper case or Lower case)
SELECT UPPER(EMP_LNAME) + ', ' + UPPER(EMP_FNAME)
FROM EMPLOYEE;

SELECT LOWER(EMP_LNAME) + ', ' + LOWER(EMP_FNAME)
FROM EMPLOYEE;

-- SUBSTRING  (Returns part of a string)
SELECT EMP_PHONE, SUBSTRING(EMP_PHONE,1,3) AS PREFIX
FROM EMPLOYEE;

-- LENGTH (Returns the number of characters in a string value)
SELECT EMP_LNAME, LEN(EMP_LNAME) AS NAMESIZE
FROM EMPLOYEE; 
GO 

-- CONVERSION FUNCTIONS (Take a data type and convert to another data type)
-- Numeric to Character
-- CAST (numeric as varchar(length)
-- CONVERT (varchar(length), numeric)
SELECT P_CODE, CAST(P_PRICE AS VARCHAR(8)) AS PRICE,
	CONVERT(VARCHAR(4), P_QOH) AS QUANTITY, 
	CAST(P_DISCOUNT AS VARCHAR(4)) AS DISCOUNT, 
	CAST(P_PRICE *P_QOH AS VARCHAR(10)) AS TOTAL_COST
FROM PRODUCT;


-- Date to Character
-- CAST (date AS varchar(length))
-- CONVERT (varchar(length), date)
SELECT EMP_LNAME, EMP_DOB,
	CONVERT(VARCHAR(11), EMP_DOB) AS "DATE OF BIRTH"
FROM EMPLOYEE;

SELECT EMP_LNAME, EMP_DOB,
	CAST(EMP_DOB AS VARCHAR(11)) AS "DATE OF BIRTH"
FROM EMPLOYEE;

-- String to Number
-- CAST 
SELECT CAST('-123.99' AS NUMERIC(8,2)),
		CAST('-99.78' AS NUMERIC(8,2))
		
-- CASE (Compares an attribute of expression with a series of values or a default value if no match is found)
SELECT V_CODE, V_STATE,
	CASE WHEN V_STATE = 'CA' THEN .08
		WHEN V_STATE = 'FL' THEN .05
		WHEN V_STATE = 'TN' THEN .085
	ELSE 0.00 END AS TAX			
FROM VENDOR;
GO		
-- UPDATEABLE VIEWS
-- To work with this we will be adding and deleting some tables in each run.
IF OBJECT_ID ('PRODMASTER', 'U') IS NOT NULL 
DROP TABLE PRODMASTER;
GO 
IF OBJECT_ID ('PRODSALES','U') IS NOT NULL
DROP TABLE PRODSALES;
GO 		
-- Build the tables	
CREATE TABLE PRODMASTER (
PROD_ID   VARCHAR(4) PRIMARY KEY,
PROD_DESC VARCHAR(20),
PROD_QOH  NUMERIC(5,2));

CREATE TABLE PRODSALES (
PROD_ID VARCHAR(4) PRIMARY KEY,
PS_QTY  NUMERIC(5,2));

INSERT INTO PRODMASTER VALUES ('A123', 'SCREWS', 67);
INSERT INTO PRODMASTER VALUES ('BX34', 'NUTS'  , 37);
INSERT INTO PRODMASTER VALUES ('C583', 'BOLTS' , 50);

INSERT INTO PRODSALES VALUES ('A123', 7);
INSERT INTO PRODSALES VALUES ('BX34', 3);	
GO

-- In this we will be update the PRODMASTER table by subtracting  the PRODSALES table's product PS_QTY from the 
-- PRODMASTER PROD_QOH. This would be similar to a batch run at night to reconcile quantity on hand. 
-- Example Below will not work 
/*
UPDATE PRODMASTER, PRODSALES
SET PRODMASTER.PROD_QOH = PROD_QOH - PS_QTY
WHERE PRODMASTER.PROD_ID = PRODSALES.ID;

This is because the update does not expect to see to two tables. To solve this problem we need an updatable view. 
This is a view that can be used to update attributes in the base table(s) that is (are) used in the view.
NOT ALL VIEWS are UPDATABLE. 

-- Creating a Updateable VIEW
--  Most common updatable view restrictions are as follows
--   *GROUP BY experessions or aggregate functions cannot be used
--	 *You cannot use set operators such as UNION, INTERSECT, AND MINUES
--   *Most restrictions are based on the use of JOINs or group operators in views.

*/	
-- To Drop and recreate
IF OBJECT_ID ('PSVUPD','V') IS NOT NULL
DROP VIEW PSVUPD
GO 
Create View PSVUPD AS (
	SELECT PRODMASTER.PROD_ID, PRODMASTER.PROD_QOH, PRODSALES.PS_QTY
	FROM PRODMASTER, PRODSALES
	WHERE PRODMASTER.PROD_ID = PRODSALES.PROD_ID); 
GO
-- To make sure that you can use the view to update a base tables the Primary key still has unique values.

SELECT * FROM PSVUPD;

-- From here you can use a UPDATE to PSVUPD to update the PRODMASTER TABLE
SELECT * FROM PRODMASTER;

UPDATE PSVUPD
	SET PROD_QOH = PROD_QOH - PS_QTY;

SELECT * FROM PRODMASTER;
GO 

-- PROCEDUAL SQL 
-- This is the implementation of traditional programming constructs, such as variables, conditional processing (IF-THEN-ELSE)
--, basic loops (FOR and WHILE loops,) and error trapping.

-- Syntax
/*
BEGIN 
	CODE
END
*/

-- EXAMPLE Anonymous : Add a row to the Vendor table and print confirmation
BEGIN
	INSERT INTO VENDOR
	VALUES (25678, 'MicroSoft Corp', 'Bill Gates','765', '546-8484','WA','N')
	PRINT 'New Vendor Added'
END;
		
-- EXAMPLE Anonymous: demonstrate several constucts supported by the procedual language
DECLARE @W_P1 INTEGER 
DECLARE @W_P2 INTEGER 
DECLARE @W_NUM INTEGER
SET @W_P1 = 0
SET @W_P2 = 10
SET @W_NUM = 0
WHILE @W_P2 < 300 
BEGIN
   SET @W_NUM = (SELECT COUNT(P_CODE)FROM PRODUCT WHERE P_PRICE BETWEEN @W_P1 AND @W_P2)
   PRINT('There are ' + cast(@W_NUM as varchar(10)) + ' Products with price between ' + cast(@W_P1 as varchar(10)) + ' and ' + cast(@W_P2 as varchar(10)))
   SET @W_P1 = @W_P2 + 1
   SET @W_P2 = @W_P2 + 50  
END

-- EXPLANATION: The above code is looking through the Product lists to find the number of items that are priced between 
-- @W_P1 AND @W_P2, and prints the total in a sentence. This code is incremented each time the code is ran 50 is added 
-- to W_P2, and the value of W_P2 + 1 is set as W_P1. Till W_P2 = 300

-- It uses DECLARE and SET to create and insert values into the variables
-- A WHILE loop is used to increment the variables
-- Several SQL statements are used as well CAST and COUNT to work this Transact SQL

-- Trigger is a procedural SQL code that is automatically invoked by the RDBMS upon the occurance of a given data manipulation event.
-- * A Trigger is invoked before or after a data row is inserted, updated, or deleted
-- * A Trigger is associated with a database table.
-- * Each database table may have one or more Triggers.
-- * A Trigger is executed as part of the Transaction that triggered it. 

-- Recommended for:
-- Auditing purposes
-- Automatic generation of derived column values
-- Enforcement of business or security constraints
-- Creation of replica tables for back-up proposes

-- EXAMPLE: In this scenerio we will build a trigger to create populate a flag
-- in the P_REORDER column (1 = YES, 0 = NO). The initial values have already been set to 0
-- From examining the table we have the QOH, the MIN, and a MIN_ORDER for each product

SELECT * FROM PRODUCT;
IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'TRG_PRODUCT_REORDER' AND type = 'TR')
   DROP TRIGGER TRG_PRODUCT_REORDER
GO
CREATE TRIGGER TRG_PRODUCT_REORDER
ON PRODUCT
FOR INSERT, UPDATE 
AS
BEGIN 
   IF UPDATE(P_QOH)
   BEGIN
   UPDATE PRODUCT
       	SET P_REORDER = 1 
       	WHERE P_QOH <= P_MIN;
   END
END;
GO 
-- To test this we will look at product '11QER/31' and then UPDATE the QOH by 4 to see the TRIGGER. 
SELECT * FROM PRODUCT WHERE P_CODE = '11QER/31'

UPDATE PRODUCT 
	SET P_QOH = 4
	WHERE P_CODE = '11QER/31'

SELECT * FROM PRODUCT WHERE P_CODE = '11QER/31'	
GO
-- Though what happens when you update the min?
SELECT * FROM PRODUCT WHERE P_CODE = '2232/QWE'

UPDATE PRODUCT
	SET P_MIN = 7 
	WHERE P_CODE = '2232/QWE'
	
SELECT * FROM PRODUCT WHERE P_CODE = '2232/QWE'	

-- This does not intiate the trigger becuase the trigger is only looking at the P_QOH column
-- To avoide this inconsistency, we must modify the trigger event to execute after the P_min field, too.

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'TRG_PRODUCT_REORDER' AND type = 'TR')
   DROP TRIGGER TRG_PRODUCT_REORDER
GO
CREATE TRIGGER TRG_PRODUCT_REORDER
ON PRODUCT
FOR INSERT, UPDATE 
AS
BEGIN 
   IF UPDATE(P_QOH)
   BEGIN
   UPDATE PRODUCT
       	SET P_REORDER = 1 
       	WHERE P_QOH <= P_MIN;
   END
   IF UPDATE(P_MIN)
   BEGIN
   UPDATE PRODUCT
       	SET P_REORDER = 1 
       	WHERE P_QOH <= P_MIN;
   END
END;
GO 

-- Test 
SELECT * FROM PRODUCT WHERE P_CODE = '23114-AA'

UPDATE PRODUCT
	SET P_MIN = 10
	WHERE P_CODE = '23114-AA'
	
SELECT * FROM PRODUCT WHERE P_CODE = '23114-AA'
GO 

-- This seems to work well, but what about if you change the P_QOH value to above the MIN with a Flag 1 in the P_REORDER FIELD.
SELECT * FROM PRODUCT WHERE P_CODE = '11QER/31'

UPDATE PRODUCT
	SET P_QOH = P_QOH + P_MIN_ORDER
		WHERE P_CODE = '11QER/31'
		
SELECT * FROM PRODUCT WHERE P_CODE = '11QER/31'
GO 		

-- Yes, this does not delete the 1 in the P_REORDER field.
-- To do this we will need to modify the trigger. Since, in its current state it only changes is it to 1.
-- EXPLANATION: is commented throughout the coding.

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'TRG_PRODUCT_REORDER' AND type = 'TR')
   DROP TRIGGER TRG_PRODUCT_REORDER
GO

CREATE TRIGGER TRG_PRODUCT_REORDER
ON PRODUCT
FOR INSERT, UPDATE 
AS
	DECLARE @P_QOH INTEGER,
	@P_MIN INTEGER,
	@P_REORDER INTEGER
	IF UPDATE (P_QOH)
	BEGIN
	SELECT @P_QOH = I.P_QOH, @P_MIN = I.P_MIN 
		FROM PRODUCT P INNER JOIN INSERTED I
		ON P.P_QOH = I.P_QOH
		-- The INSERTED table stores copies of the affected rows during INSERT and UPDATE statements. 
		-- During an insert or update transaction, new rows are added to both the inserted table and the trigger table. 
		-- The rows in the inserted table are copies of the new rows in the trigger table.
		-- By using the INSERTED table the SQL is only reviewing the updated or inserted changes. 
		-- This reduces the overall amount of time that is used. 
	IF @P_QOH <= @P_MIN -- This compares the new values in the changed rows due to a INSERT OR UPDATE
		UPDATE PRODUCT SET P_REORDER = 1
	ELSE
		UPDATE PRODUCT SET P_REORDER = 0
	END
	IF UPDATE (P_MIN)
	BEGIN
	SELECT @P_QOH = I.P_QOH, @P_MIN = I.P_MIN 
		FROM PRODUCT P INNER JOIN INSERTED I
		ON P.P_QOH = I.P_QOH
	IF @P_QOH <= @P_MIN
		UPDATE PRODUCT SET P_REORDER = 1
	ELSE
		UPDATE PRODUCT SET P_REORDER = 0
	END
GO 
-- Testing code 
-- Note that P_CODE '11QER/31' currently has a QOH that is above the min but still has reorder flad of 1.

SELECT * FROM PRODUCT;

-- FORCE UPDATE

UPDATE PRODUCT
	SET P_QOH = P_QOH;
	
SELECT * FROM PRODUCT WHERE P_CODE = '11QER/31';

-- Finally, a solution for all types of UPDATES AND INSERTS ON THE PRODUCT TABLE.	

-- Additional Examples: What about a trigger that effects another table?
-- For every sale of an item on the LINE table, lets create a trigger to reduce the QOH in the PRODUCT table. 

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'TRG_LINE_PROD' AND type = 'TR')
   DROP TRIGGER TRG_LINE_PROD
GO
CREATE TRIGGER TRG_LINE_PROD
ON LINE
FOR INSERT
AS
BEGIN
   UPDATE PRODUCT
     SET P_QOH = (SELECT PRODUCT.P_QOH-INSERTED.LINE_UNITS FROM PRODUCT, INSERTED
   	 WHERE PRODUCT.P_CODE = INSERTED.P_CODE)
END;
GO

-- Increase the customer balance in the CUSTOMER Table after inserting a new LINE row.

IF EXISTS (SELECT name FROM sysobjects
      WHERE name = 'TRG_LINE_CUS' AND type = 'TR')
   DROP TRIGGER TRG_LINE_CUS
GO
CREATE TRIGGER TRG_LINE_CUS
ON LINE 
FOR INSERT
AS
DECLARE 
@W_CUS CHAR(5),
@W_TOT NUMERIC
SET @W_TOT = 0    -- to compute total cost
   -- this trigger fires up after an INSERT of a LINE
   -- it will update the CUS_BALANCE in CUSTOMER   

   -- 1) get the CUS_CODE
   SET @W_CUS = (SELECT INVOICE.CUS_CODE FROM INVOICE, INSERTED WHERE INVOICE.INV_NUMBER = INSERTED.INV_NUMBER)

   -- 2) compute the total of the current line
   SET @W_TOT = (SELECT INSERTED.LINE_PRICE*INSERTED.LINE_UNITS FROM INSERTED)
    
   -- 3) Update the CUS_BALANCE in CUSTOMER
   UPDATE CUSTOMER
    SET CUS_BALANCE = CUS_BALANCE + @W_TOT
     WHERE CUS_CODE = @W_CUS;

   PRINT(' * * * Balance updated for customer: ' + @W_CUS);  
GO


-- STORED PROCEDURES is a named collection of procedural SQL statements.
-- Assume you want to create a procedure to assign an additional 5 percent discount for all products wht the QOH
-- is more than or equal to twice the minimum quantity.

IF EXISTS (SELECT name FROM sysobjects 
   WHERE name = 'PRC_PROD_DISCOUNT' AND type = 'P')
   DROP PROCEDURE PRC_PROD_DISCOUNT
GO
CREATE PROCEDURE PRC_PROD_DISCOUNT 
AS
BEGIN
   UPDATE PRODUCT
     SET P_DISCOUNT = P_DISCOUNT + .05
       WHERE P_QOH >= P_MIN*2;
   PRINT('* * Update finished * *')
END
GO

-- Test Procedure
SELECT * FROM PRODUCT;

EXEC PRC_PROD_DISCOUNT;

SELECT * FROM PRODUCT;

-- What if you want to set the % as a variable?

IF EXISTS (SELECT name FROM sysobjects 
   WHERE name = 'PRC_PROD_DISCOUNT' AND type = 'P')
   DROP PROCEDURE PRC_PROD_DISCOUNT
GO
CREATE PROCEDURE PRC_PROD_DISCOUNT
@WPI NUMERIC(3,2)
AS
BEGIN
   IF (@WPI <= 0) OR (@WPI >= 1) -- validate WPI parameter 
   BEGIN
      PRINT('Error: Value must be greater than 0 and less than 1')
   END
   ELSE 
   -- if value is greater than 0 and less than 1
   UPDATE PRODUCT
   SET P_DISCOUNT = P_DISCOUNT + @WPI
   WHERE P_QOH >= P_MIN*2;
   PRINT ('* * Update finished * *')
END
GO 

EXEC PRC_PROD_DISCOUNT 1.5
GO -- This will cause the error to be thrown
EXEC PRC_PROD_DISCOUNT .05
GO

-- Additional Examples: stored procedure to add a new customer. 

IF EXISTS (SELECT name FROM sysobjects 
   WHERE name = 'PRC_CUS_ADD' AND type = 'P')
   DROP PROCEDURE PRC_CUS_ADD
GO
CREATE PROCEDURE PRC_CUS_ADD
@W_CODE INTEGER,
@W_LN VARCHAR(15),
@W_FN VARCHAR(15),
@W_INIT CHAR(1),
@W_AC CHAR(3),
@W_PH CHAR(8)
AS
BEGIN
-- attribute names are required when not giving values for all table attributes
   INSERT INTO CUSTOMER(CUS_CODE,CUS_LNAME, CUS_FNAME, CUS_INITIAL, CUS_AREACODE, CUS_PHONE)
          VALUES (@W_CODE, @W_LN, @W_FN, @W_INIT, @W_AC, @W_PH);  
   PRINT ('Customer ' + @W_LN + ', ' + @W_FN + ' added.');
END;
GO 

-- Test

EXEC PRC_CUS_ADD 10023,'Walker','Johnie',NULL,'615','84-DRUNK'

SELECT * FROM CUSTOMER WHERE CUS_LNAME = 'Walker';
GO

--Additional Examples stored procedure for Product
IF EXISTS (SELECT name FROM sysobjects 
   WHERE name = 'PRC_LINE_ADD' AND type = 'P')
   DROP PROCEDURE PRC_LINE_ADD
GO

CREATE PROCEDURE PRC_LINE_ADD
@W_IN NUMERIC (4),
@W_LN NUMERIC(5),
@W_P_CODE VARCHAR(10),
@W_LU NUMERIC(5)
AS
BEGIN
DECLARE @W_LP NUMERIC(5)
   -- GET THE PRODUCT PRICE
	SET @W_LP = (SELECT P_PRICE FROM PRODUCT
	            WHERE P_CODE = @W_P_CODE)

   -- ADDS THE NEW LINE ROW   
	INSERT INTO LINE (INV_NUMBER, LINE_NUMBER, P_CODE, LINE_UNITS, LINE_PRICE)
          VALUES(@W_IN, @W_LN, @W_P_CODE, @W_LU, @W_LP);

	PRINT('Invoice line ' + @W_LN + ' added');
END;
GO 

-- Additional Examples stored procedure to insert invoice 

IF EXISTS (SELECT name FROM sysobjects 
   WHERE name = 'PRC_INV_ADD' AND type = 'P')
   DROP PROCEDURE PRC_INV_ADD
GO
CREATE PROCEDURE PRC_INV_ADD
@W_INV_NUM INTEGER,
@W_CUS_CODE INTEGER,
@W_DATE DATETIME
AS
BEGIN
   INSERT INTO INVOICE (INV_NUMBER, CUS_CODE, INV_DATE)
          VALUES(@W_INV_NUM, @W_CUS_CODE, @W_DATE);
   PRINT('Invoice added');
END;
GO 
-- Testing the procedures to insert a new INVOICE and LINE

EXEC PRC_INV_ADD 1010,10010,'09-APR-2010'
--EXEC PRC_LINE_ADD 1010, 1,'13-Q2/P2',1   -- Adds first line of invoice
--EXEC PRC_LINE_ADD 1010, 2,'23109-HB',2   -- Adds second line of invoice

SELECT * FROM INVOICE WHERE CUS_CODE = 10010;
SELECT * FROM LINE WHERE INV_NUMBER  = (SELECT INV_NUMBER FROM INVOICE WHERE CUS_CODE = 10010);
SELECT * FROM PRODUCT WHERE P_CODE IN ('13-Q2/P2', '23109-HB'); 
SELECT * FROM CUSTOMER WHERE CUS_CODE = 10010;
GO 


-- Cursor Procedure
-- is a special construct use in procedual SQL to hold the data rows returned by an SQL query.
-- Two Types: implicit - is automatically created in procedural SQL when the SQL statement returns only one value. 
-- explicit - is created to hold the output of an SQL statement that may return two or more rows (but could return 
-- 0 or only one row)

-- Cursor Processing Commends:
-- OPEN - EXECUTES THE SQL command and populates the cursor with data
-- FETCH - to retrieve data from the cursor and copy it 
-- CLOSE - closes the cursor. 

IF EXISTS (SELECT name FROM sysobjects 
   WHERE name = 'PRC_CURSOR_EXAMPLE' AND type = 'P')
   DROP PROCEDURE PRC_CURSOR_EXAMPLE
GO
CREATE PROCEDURE PRC_CURSOR_EXAMPLE 
AS
DECLARE @W_P_CODE	VARCHAR(10)
DECLARE @W_P_DESCRIPT	VARCHAR(35)
DECLARE @W_TOT		INTEGER
DECLARE PROD_CURSOR CURSOR 
   FOR SELECT P_CODE, P_DESCRIPT FROM PRODUCT WHERE P_QOH > (SELECT AVG(P_QOH) FROM PRODUCT)
BEGIN
PRINT('PRODUCTS WITH P_QOH > AVG(P_QOH)')
PRINT('======================================')
OPEN PROD_CURSOR
FETCH NEXT FROM PROD_CURSOR INTO @W_P_CODE, @W_P_DESCRIPT
WHILE @@FETCH_STATUS=0
BEGIN
PRINT(@W_P_CODE + ' -> ' + @W_P_DESCRIPT )
FETCH NEXT FROM PROD_CURSOR INTO @W_P_CODE, @W_P_DESCRIPT   
END
PRINT('======================================')
PRINT('TOTAL PRODUCT PROCESSED ' + cast(@@CURSOR_ROWS as varchar(10)))
PRINT('--- END OF REPORT ----')
CLOSE PROD_CURSOR
DEALLOCATE PROD_CURSOR -- HAVE TO RELEASE THE MEMORY
END
GO 

EXEC PRC_CURSOR_EXAMPLE;
GO

-- EMMBEDDED SQL framework defines the following:
-- * A standard syntax to identify embedded SQL code within the host language (EXEC SQL/ END-EXEC)
-- * A standard syntax to identiy host variables. Host variables are variables in the Host that retreive data fromt he 
-- the database  (through the embedded SQL code) and process the data in the host language. All host variables are preceded by a colon (":")
-- * A communication area used to exchange status and errror information between SQL and the host lanquage. This 
-- communication ara contains two variables  - SQLCODE and SQLSTATE.






