USE NWIND
GO 

PRINT 'This is my Final problems for IS 301 Class'

PRINT 'Code to remove table for problem 5'

BEGIN TRANSACTION
IF OBJECT_ID ('EXAM3_JP', 'U') IS NOT NULL 
DROP TABLE EXAM3_JP;
GO 

PRINT 'PROBLEM 6'
INSERT INTO EXAM3_JP VALUES ( 'JEP1','The book for this class should really be in Oracle and SQL, and not Oracle ane Access',	
			'JEP','2056175550','08-DEC-2011',1);
GO
