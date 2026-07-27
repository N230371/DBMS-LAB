## PART A - VERIFY WEEK1 DATABASE
USE taxation_db;
SHOW TABLES;

## PART B - BUILT-IN STRING FUNCTIONS
# LEVEL 1:

# 1.
SELECT UPPER(full_name) AS full_name
FROM taxpayer;

# 2.
SELECT LOWER(occupation) AS occupation
FROM taxpayer;

# 3.
SELECT full_name,LENGTH(full_name) AS length
FROM taxpayer;

# 4.
SELECT full_name, LEFT(pan_number,4)
FROM taxpayer;

# 5.
SELECT CONCAT(full_name,' - ', occupation) AS taxpayer
FROM taxpayer;

# LEVEL 2

# 6.
SELECT REPLACE(category_name,'Income','Inc') AS new_category_name
FROM income_category;

# 7.
SELECT TRIM(full_name) AS full_name
FROM taxpayer;

# 8.
SELECT LEFT(full_name, LOCATE(' ', full_name) - 1) 
AS first_name
FROM taxpayer;

# LEVEL 3

# 9.
SELECT CONCAT(occupation,':',full_name) 
AS taxpayer
FROM taxpayer;

# 10.
SELECT pan_number
FROM taxpayer
WHERE LEFT(pan_number,2) = 'AP';


## PART C - BUILT-IN NUMERIC FUNCTIONS

# LEVEL 1:

# 1.
SELECT ROUND(annual_income,2) 
AS annual_income
FROM taxpayer;

# 2.
SELECT ABS(annual_income) 
AS annual_income
FROM taxpayer;

# 3.
SELECT (annual_income*annual_income) 
AS annual_income
FROM taxpayer;

# LEVEL 2

# 4.
SELECT MOD(annual_income,1000) 
AS annual_income
FROM taxpayer;

# 5.
SELECT ROUND(annual_income,2) 
AS annual_income
FROM taxpayer;

# 6.
SELECT CEIL(annual_income),annual_income,FLOOR(annual_income) 
FROM taxpayer;

# LEVEL 3

# 7.
SELECT FLOOR(RAND()*100)+1;

# 8.
SELECT SQRT(annual_income) 
AS annual_income
FROM taxpayer;

# 9.
SELECT 
full_name,
annual_income,
annual_income * 1.10 AS estimated_income
FROM taxpayer;

## PART D - DATE FUNCTIONS

# LEVEL 1

# 1.
SELECT CURDATE();

# 2.
SELECT NOW();

# 3.
SELECT YEAR(start_date)
FROM financial_year;

# 4.
SELECT MONTH(start_date)
FROM financial_year;

# 5.
SELECT DAY(start_date)
FROM financial_year;

# LEVEL 2

# 6.
SELECT start_date, DATE_ADD(start_date,INTERVAL 1 YEAR) AS end_year
FROM financial_year;

# 7.
SELECT start_date, DATE_ADD(start_date,INTERVAL 30 DAY) AS next_month
FROM financial_year;

# 8.
SELECT start_date, DATE_SUB(start_date,INTERVAL 7 DAY) AS next_month
FROM financial_year;

# LEVEL 3

# 9.
SELECT  DATEDIFF(CURDATE(),start_date) AS days_difference
FROM financial_year;

# 10.
SELECT start_date
FROM financial_year
WHERE YEAR(start_date) = CURDATE();

## PART E - CONVERSION FUNCTION

# LEVEL 1

# 1.
SELECT CONVERT(annual_income,SIGNED)
FROM taxpayer;

# 2.
SELECT CONVERT(taxpayer_id,CHAR)
FROM taxpayer;

# LEVEL 2

# 3.
SELECT CONVERT(start_date,DATETIME)
FROM financial_year;

# 4.
SELECT CONVERT(annual_income,DECIMAL(10,2))
FROM taxpayer;

# LEVEL 3

# 5.
SELECT CONVERT(annual_income,CHAR)
FROM taxpayer;

# 6.
SELECT full_name,
CONVERT(annual_income, DECIMAL(10,2)) * 0.10 AS tax
FROM taxpayer;


