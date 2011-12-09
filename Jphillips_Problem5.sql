USE NWIND
GO 

PRINT 'This is my Final problems for IS 301 Class'

PRINT 'Code to remove table for problem 5'

BEGIN TRANSACTION
IF OBJECT_ID ('EXAM3_JP', 'U') IS NOT NULL 
DROP TABLE EXAM3_JP;
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