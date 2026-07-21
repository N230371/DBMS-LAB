# PART A - REDESGINING THE DATABASE

-- STEP 1
ALTER TABLE Income_Record
DROP COLUMN Category_name,
DROP COLUMN financial_year;

-- STEP 2
ALTER TABLE Income_Record
ADD COLUMN Category_id INT,
ADD COLUMN Year_id INT;

-- STEP 3
ALTER TABLE Income_Record
ADD CONSTRAINT income_taxpayer
FOREIGN KEY (taxpayer_id)
REFERENCES taxpayer(taxpayer_id);

ALTER TABLE Income_Record
ADD CONSTRAINT income_Category
FOREIGN KEY (category_id)
REFERENCES Income_Category(category_id);

ALTER TABLE Income_Record
ADD CONSTRAINT income_financial
FOREIGN KEY (year_id)
REFERENCES Financial_Year(year_id);

-- STEP 4
UPDATE Income_Record
SET 
    category_id = CASE income_id
        WHEN 1001 THEN 1 
        WHEN 1002 THEN 1 
        WHEN 1003 THEN 2 
        WHEN 1004 THEN 1 
        WHEN 1005 THEN 2 
        WHEN 1006 THEN 2 
    END,
    year_id = CASE income_id
        WHEN 1001 THEN 6 
        WHEN 1002 THEN 6 
        WHEN 1003 THEN 6 
        WHEN 1004 THEN 6 
        WHEN 1005 THEN 6 
        WHEN 1006 THEN 6  
    END
WHERE income_id IN (1001, 1002, 1003,1004,1005,1006);

ALTER TABLE Income_Record
MODIFY category_id INT NOT NULL,
MODIFY year_id INT NOT NULL;

# PART B - VERIFYING FOREIGN KEYS

## TASK 1
# Try inserting a new income record using
# taxpayer_id = 999
INSERT INTO Income_Record 
(income_id,taxpayer_id,income_source,amount, received_date,remarks,category_id,year_id)
VALUES
(1007,999,"TechNova Sloutions",850000.00,"2026-03-31","",1,6);
# Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`taxation_db`.`income_record`, CONSTRAINT `income_taxpayer` FOREIGN KEY (`taxpayer_id`) REFERENCES `taxpayer` (`taxpayer_id`))
# This gave error because the income_record and taxpayer are connected to the forgein key the record for the 999 taxpayer doesnot exist on the taxpayer but we are trying to add the record of the 999 taxpayer on the income record.

## Task 2
# Try inserting
# category_id = 20
INSERT INTO Income_Record 
(income_id,taxpayer_id,income_source,amount, received_date,remarks,category_id,year_id)
VALUES
(1007,999,"TechNova Sloutions",850000.00,"2026-03-31","",20,6);
# Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`taxation_db`.`income_record`, CONSTRAINT `income_taxpayer` FOREIGN KEY (`taxpayer_id`) REFERENCES `taxpayer` (`taxpayer_id`))
# The error occured because the category table doesn't contains the id=20 which we are trying to insert on the income record.

## Task 3
# Try inserting
# year_id = 15
INSERT INTO Income_Record 
(income_id,taxpayer_id,income_source,amount, received_date,remarks,category_id,year_id)
VALUES
(1007,999,"TechNova Sloutions",850000.00,"2026-03-31","",1,15);
# Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`taxation_db`.`income_record`, CONSTRAINT `income_taxpayer` FOREIGN KEY (`taxpayer_id`) REFERENCES `taxpayer` (`taxpayer_id`))
# The error occured because the id=15 doesn't exist on the financial year table and which we are trying to insert on the income record table.

## Task 4
# Try deleting a taxpayer whose records already exist in Income_Record.
DELETE FROM Taxpayer
WHERE taxpayer_id =106;
# Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`taxation_db`.`income_record`, CONSTRAINT `income_taxpayer` FOREIGN KEY (`taxpayer_id`) REFERENCES `taxpayer` (`taxpayer_id`))
# The error is due to the id of the taxpayer is existed on the income record as the two tables are related the it is throughing the error.

## Task 5
# Try deleting an income category that is currently being used by one or more
# income records.
DELETE FROM Income_Category
WHERE category_id = 1;
# Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`taxation_db`.`income_record`, CONSTRAINT `income_Category` FOREIGN KEY (`category_id`) REFERENCES `income_category` (`category_id`))
# The error is due to the id of the category is existed on the income record as the two tables are related the it is throughing the error.

## Task 6
# Write a short note explaining:

# What is a Foreign Key?
-- A Foregin Key is a cloumn or a set of columns in one table that refers to the primary key of the another table.
-- It creates a relationship between the two tables and ensures that the value in the foreign key cloumn matches and existing value in the referenced table.

# What is Referential Integrity?
-- Referential Integrity is a database rule that ensures relationships between tables remain accurate and consistent.
-- It prevents invalid records by ensuring that every forgein key value corresponds to an existing primary key value in the referenced table.

# Why are Foreign Keys required?
-- To maintain data integrity by preventing invalid references between tables.
-- Establish relationships between related tables in a relational database.
-- Reduce data redundancy by storing only reference IDs instead of repeating the same information.
-- Ensure consistency when inserting, updating, or deleting related data.
-- Improve database design by supporting normalization and making data easier to manage.

# PART C - DISTINCT

# TASK 1
SELECT DISTINCT occupation
FROM Taxpayer;

# TASK 2
SELECT DISTINCT category_name
FROM Income_Category;

# TASK 3
SELECT DISTINCT year_label
FROM Financial_Year;

# TASK 4
SELECT DISTINCT income_source
FROM Income_Record;

## PART D - UNION

# TASK 1
SELECT t.full_name
FROM Taxpayer t
JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

JOIN Income_Category c
ON i.category_id = c.category_id
WHERE c.category_name = 'Salary'

UNION

SELECT t.full_name
FROM Taxpayer t
JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

JOIN Income_Category c
ON i.category_id = c.category_id
WHERE c.category_name = 'Bussiness';

# TASK 2

SELECT c.category_name,f.year_label
FROM Income_Category c

JOIN Income_Record i
ON c.category_id = i.category_id

JOIN Financial_Year f
ON i.year_id = f.year_id
WHERE f.year_label = '2024-2025'

UNION

SELECT c.category_name,f.year_label
FROM Income_Category c

JOIN Income_Record i
ON c.category_id = i.category_id

JOIN Financial_Year f
ON i.year_id = f.year_id
WHERE f.year_label = '2025-2026';


# TASK 3
SELECT full_name,occupation
FROM Taxpayer t
WHERE occupation = 'Teacher'
UNION
SELECT full_name,occupation
FROM Taxpayer
WHERE occupation = 'Software Engineer';


## PART E - INTERSECT

# TASK 1

SELECT t.full_name
FROM Taxpayer t

JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

JOIN Income_Category c
ON i.category_id = c.category_id

WHERE c.category_name IN ('Salary','Business')
GROUP BY t.taxpayer_id, t.full_name

HAVING COUNT(DISTINCT c.category_name) = 2;

# TASK 2

SELECT t.full_name
FROM Taxpayer t

JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

JOIN Financial_Year f
ON i.year_id = f.year_id

WHERE f.year_label IN ('2024-2025', '2025-2026')
GROUP BY t.taxpayer_id
HAVING COUNT(DISTINCT f.year_label) = 2;

# PART F – EXCEPT (MINUS)

# TASK 1
SELECT DISTINCT t.full_name
FROM Taxpayer t

JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

JOIN Income_Category c
ON i.category_id = c.category_id
WHERE c.category_name = 'Salary'

AND t.taxpayer_id NOT IN
(
    SELECT i.taxpayer_id
    FROM Income_Record i
    
    JOIN Income_Category c
	ON i.category_id = c.category_id
    WHERE c.category_name = 'Business'
);

# TASK 2
SELECT DISTINCT t.full_name
FROM Taxpayer t

JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

JOIN Financial_Year f
ON i.year_id = f.year_id
WHERE f.year_label = '2025-2026'

AND t.taxpayer_id NOT IN (
    SELECT i.taxpayer_id
    FROM Income_Record i
    JOIN Financial_Year f
    ON i.year_id = f.year_id
    WHERE f.year_label = '2024-2025'
);

# Part G – Nested Queries using IN

# TASK 1
SELECT full_name
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
);

# TASK 2
SELECT full_name, occupation
FROM Taxpayer
WHERE occupation IN
(
    SELECT occupation
    FROM Taxpayer
    WHERE taxpayer_id IN
    (
        SELECT taxpayer_id
        FROM Income_Record
        WHERE category_id IN
        (
            SELECT category_id
            FROM Income_Category
            WHERE category_name = 'Bussiness'
        )
    )
);

# Part H – Nested Queries using NOT IN

# TASK 1
SELECT full_name
FROM Taxpayer
WHERE taxpayer_id  NOT IN (
    SELECT taxpayer_id
    FROM Income_Record
);

# TASK 2
SELECT DISTINCT occupation
FROM Taxpayer
WHERE occupation NOT IN
(
    SELECT occupation
    FROM Taxpayer
    WHERE taxpayer_id IN
    (
        SELECT taxpayer_id
        FROM Income_Record
    )
);

# Part I – EXISTS

# TASK 1
SELECT t.full_name
FROM Taxpayer t
WHERE EXISTS (
    SELECT 1
    FROM Income_Record i
    WHERE i.taxpayer_id = t.taxpayer_id
);

# TASK 2
SELECT f.year_label
FROM Financial_Year f
WHERE EXISTS (
    SELECT 1
    FROM Income_Record i
    WHERE i.year_id = f.year_id
);

# Part J – NOT EXISTS

# Task 1
SELECT t.full_name
FROM Taxpayer t
WHERE NOT EXISTS (
    SELECT 1
    FROM Income_Record i
    WHERE i.taxpayer_id = t.taxpayer_id
);

# Task 2
SELECT c.category_name
FROM Income_Category c
WHERE NOT EXISTS (
    SELECT 1
    FROM Income_Record i
    WHERE i.category_id = c.category_id
);

# Part K – ANY

# TASK 1
SELECT full_name, annual_income
FROM Taxpayer
WHERE annual_income > ANY (
    SELECT annual_income
    FROM Taxpayer
    WHERE occupation = 'Teacher'
);

# TASK 2
SELECT full_name, annual_income
FROM Taxpayer
WHERE annual_income > ANY
(
    SELECT annual_income
    FROM Taxpayer
    WHERE taxpayer_id IN
    (
        SELECT taxpayer_id
        FROM Income_Record
        WHERE category_id IN
        (
            SELECT category_id
            FROM Income_Category
            WHERE category_name = 'Bussiness'
        )
    )
);

# Part L – ALL

# TASK 1
SELECT full_name, annual_income
FROM Taxpayer
WHERE annual_income > ALL (
    SELECT annual_income
    FROM Taxpayer
    WHERE occupation = 'Teacher'
);

# TASK 2
SELECT full_name, annual_income
FROM Taxpayer
WHERE annual_income > ALL
(
    SELECT amount
    FROM Income_Record
    WHERE category_id IN
    (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Bussiness'
    )
);

# PART M - ADDITIONAL QUERY PRACTICE
# 1.
SELECT *
FROM Taxpayer
ORDER BY full_name ASC;

# 2.
SELECT *
FROM Taxpayer
WHERE annual_income > 800000;

# 3.
SELECT *
FROM Taxpayer
WHERE occupation = "software Engineer";

# 4.
SELECT i.*
FROM Income_Record i
JOIN Income_Category c
ON i.category_id = c.category_id
WHERE c.category_name = "Bussiness";

# 5.
SELECT *
FROM Income_Record
WHERE amount BETWEEN 500000 AND 1000000;

# 6.
SELECT *
FROM Taxpayer
WHERE full_name LIKE "A%";

# 7. --- the column not existed
SELECT *
FROM Taxpayer
WHERE address = "vijayawada";

# 8.
SELECT *
FROM Taxpayer
WHERE is_active = TRUE;

# 9.
SELECT COUNT(*) AS total_taxpayers
FROM Taxpayer;

# 10.
SELECT MAX(annual_income) AS highest_income
FROM Taxpayer;


## PART N - MINI CHALLENGE

# 1.
SELECT *
FROM Taxpayer
WHERE annual_income = (
    SELECT MAX(annual_income)
    FROM Taxpayer
);

# 2.
SELECT c.category_name, COUNT(i.income_id) AS total_records
FROM Income_Category c
JOIN Income_Record i
ON c.category_id = i.category_id
GROUP BY c.category_id
ORDER BY total_records DESC
LIMIT 1;

# 3.
SELECT occupation, COUNT(*) AS total_taxpayers
FROM Taxpayer
GROUP BY occupation;

# 4.
SELECT COUNT(*) AS active_taxpayers
FROM Taxpayer
WHERE is_active = TRUE;

# 5.
SELECT f.year_label, COUNT(i.income_id) AS total_records
FROM Financial_Year f
JOIN Income_Record i
ON f.year_id = i.year_id
GROUP BY f.year_id
ORDER BY total_records DESC
LIMIT 1;




