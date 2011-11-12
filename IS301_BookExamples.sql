-- CREATE TABLES
USE IS301
GO

-- Simple Drops to work on files
DROP TABLE LINE;
DROP TABLE INVOICE;
DROP TABLE CUSTOMER;
DROP TABLE PRODUCT;
DROP TABLE VENDOR;


-- Create Table with Primary Key
CREATE TABLE VENDOR (
V_CODE			INT					NOT NULL UNIQUE,
V_NAME			VARCHAR(35)			NOT NULL,
V_CONTACT		VARCHAR(15)			NOT NULL,
V_AREACODE		CHAR(3)				NOT NULL,
V_PHONE			CHAR(8)				NOT NULL,
V_STATE			CHAR(2)				NOT NULL,
V_ORDER			CHAR(1)				NOT NULL,
PRIMARY KEY (V_CODE)
)

-- Create Table with Primary Key and Foreign Key
CREATE TABLE PRODUCT(
P_CODE		VARCHAR(10)				NOT NULL UNIQUE,
P_DESCRIPT	VARCHAR(35)				NOT NULL,
P_INDATE	DATE					NOT NULL,
P_QOH		SMALLINT				NOT NULL,
P_MIN		SMALLINT				NOT NULL,
P_PRICE		NUMERIC(8,2)			NOT NULL,
P_DISCOUNT	NUMERIC(5,2)			NOT NULL,
V_CODE		INT						NOT NULL,
PRIMARY KEY (P_CODE),
FOREIGN KEY (V_CODE) REFERENCES VENDOR)


-- Create tables with Constraints

CREATE TABLE CUSTOMER (
CUS_CODE		INT			PRIMARY KEY,
CUS_LNAME		VARCHAR(15)	NOT NULL,
CUS_FNAME		VARCHAR(15)	NOT NULL, 
CUS_INITIAL		CHAR(1),
CUS_AREACODE	CHAR(3)		DEFAULT '615' NOT NULL
							CHECK(CUS_AREACODE IN ('615', '713', '931')),
CUS_PHONE		CHAR(8)		NOT NULL,
CUS_BALANCE		NUMERIC(9,2)DEFAULT 0.00,
CONSTRAINT CUS_UI1 UNIQUE (CUS_LNAME , CUS_FNAME))

CREATE TABLE INVOICE(
INV_NUMBER		INT			PRIMARY KEY, 
CUS_CODE		INT			NOT NULL REFERENCES CUSTOMER(CUS_CODE),
INV_DATE		DATE		DEFAULT CURRENT_TIMESTAMP NOT NULL,
CONSTRAINT INV_CK1 CHECK (INV_DATE > '01-JAN-2010'))

CREATE TABLE LINE (
INV_NUMBER		INT				NOT NULL,
LINE_NUMBER		NUMERIC(2,0)	NOT NULL,
P_CODE			VARCHAR(10)		NOT NULL,
LINE_UNITS		NUMERIC(9,2)	DEFAULT 0.00,
LINE_PRICE		NUMERIC(9,2)	DEFAULT 0.00,
PRIMARY KEY	(INV_NUMBER,LINE_NUMBER),
FOREIGN KEY	(INV_NUMBER) REFERENCES INVOICE, 
FOREIGN KEY	(P_CODE) REFERENCES PRODUCT(P_CODE),
CONSTRAINT LINE_UI1 UNIQUE (INV_NUMBER, P_CODE))

-- Create and Drop Index								
CREATE INDEX P_INDATEX ON PRODUCT(P_INDATE)
CREATE INDEX P_CODEX ON PRODUCT(P_CODE)
CREATE INDEX P_PRICEX ON PRODUCT(P_PRICE DESC)
DROP INDEX P_PRICEX ON PRODUCT

				
							
--INSERT DATA
INSERT INTO VENDOR
VALUES (21225,'Bryson, Inc.','Smithson','615','223-3234','TN','Y')

SELECT * FROM VENDOR

INSERT INTO VENDOR
VALUES (21226,'Superloo, Inc.','Flushing','904','215-8995','FL','N')

SELECT * FROM VENDOR

INSERT INTO PRODUCT
VALUES ('11QER/31','Power painter, 15 psi., 3-nozzle','11-03-09',8,5,109.99,0.00,21225)

INSERT INTO PRODUCT
VALUES ('13-Q2/P2','7.25-in. pwr. saw blade','12-13-09',32,15,14.99, 0.05,21225)

SELECT * FROM PRODUCT
		
-- Inserting row with a NULL for the VENDOR
INSERT INTO PRODUCT
	VALUES('BTR-345','Titanium drill bit','18-OCT-09',75,10,4.50,0.06,NULL)	
/*	 Another way to do this it below:
INSERT INTO PRODUCT	(P_CODE , P_DESCRIPT) VALUES (	'BTR-345','Titanium drill bit')
*/
SELECT * FROM PRODUCT

-- Simply put saves all changes.
COMMIT

-- SELECT 
SELECT * FROM PRODUCT

-- Trick to using the intelisense is to fill out the FROM [TABLE] first
SELECT P_CODE, P_DESCRIPT, P_QOH, P_MIN, P_PRICE,P_DISCOUNT,V_CODE
FROM PRODUCT

