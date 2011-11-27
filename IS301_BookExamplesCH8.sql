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
