USE taxation_db;
SHOW tables;
SELECT * FROM taxpayer;
SELECT * FROM income_category;
SELECT * FROM income_record;
SELECT * FROM financial_year;

INSERT INTO income_record 
(income_id,taxpayer_id,income_source,amount, received_date,remarks,category_id,year_id)
VALUES
(1007,101,"villa",850000.00,"2025-03-31","",3,5),
(1008,102,"house",1200000.00,"2025-03-31","",3,5),
(1009,103,"Reddy Enterprises",1800000.00,"2024-03-31","",4,4),
(1010,104,"Sunrise School",620000.00,"2024-03-31","",4,4),
(1011,105,"Web Design Projects",750000.00,"2023-03-31","",5,3),
(1012,106,"Professional Consulting",1500000.00,"2023-03-31","",5,3);

# PART B - AGGREGATE FUNCTIONS
-- LEVEL 1 UNDERSTANDING
-- Task1: Display the total number of income records
SELECT COUNT(*) AS count_of_income_records
FROM income_record;

-- Task 2: Display the total income amount recorded in the database. 
SELECT SUM(amount) AS total_income_amount
FROM income_record;

-- Task 3: Display the average income amount.
SELECT AVG(amount) AS total_income_amount
FROM income_record;

-- Task 4: Display the highest income amount recorded.
SELECT MAX(amount) AS total_income_amount
FROM income_record;

-- Task 5: Display the lowest income amount recorded.
SELECT MIN(amount) AS total_income_amount
FROM income_record;

-- LEVEL 2 - APPLICATION
-- Task 1: Display the number of income records for each income category
SELECT c.category_name ,COUNT(i.category_id) AS count
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;

-- Task 2: Display the total income for each income category.
SELECT c.category_name ,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;

-- Task 3: Display the average income for each income category.
SELECT c.category_name ,AVG(i.amount) AS avg_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;

-- Task 4: Display the highest income recorded in each income category.
SELECT c.category_name ,MAX(i.amount) AS highest_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;

-- Task 5: Display the lowest income recorded in each income category.
SELECT c.category_name ,MIN(i.amount) AS lowest_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;

-- Task 6: Display the total income for each financial year.
SELECT f.year_label ,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY i.year_id;

-- Task 7: Display the number of income records for each financial year.
SELECT f.year_label ,COUNT(i.year_id) AS total_records
FROM income_record AS i
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY i.year_id;

-- Task 8: Display the total income for each income category in each financial year.
SELECT c.category_name,f.year_label ,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN financial_year AS f
ON i.year_id = f.year_id
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.year_id,i.category_id;

-- LEVEL 3 - MEDIUM TO ADVANCED
-- Task 1: Display only those income categories whose total income is greater than ₹10,00,000
SELECT c.category_name ,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id
HAVING total_income > 1000000;

-- Task 2: Display income categories whose average income is greater than ₹5,00,000.
SELECT c.category_name ,AVG(i.amount) AS avg_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id
HAVING avg_income > 500000;

-- Task 3: Display financial years having more than three income records.
SELECT f.year_label ,COUNT(i.year_id) AS total_records
FROM income_record AS i
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY i.year_id
HAVING total_records > 3;

-- Task 4: Display income categories in descending order of total income.
SELECT c.category_name ,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id
ORDER BY total_income DESC;

-- Task 5: Display income categories whose total income is greater than ₹10,00,000 and arrange them from highest total income to lowest.
SELECT c.category_name ,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id
HAVING total_income > 1000000
ORDER BY total_income DESC;

-- Task 6: Display the total income and average income for each income category.
SELECT c.category_name, 
SUM(i.amount) AS total_income, 
AVG(i.amount) AS average_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;

-- Task 7: Display the category and financial year combination having the highest total income.
SELECT c.category_name, f.year_label,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY i.category_id,i.year_id
ORDER BY total_income DESC
LIMIT 1;

-- Task 8: Display the number of taxpayers who have income records in each financial year.
SELECT f.year_label,COUNT(DISTINCT t.taxpayer_id) AS count_of_taxpayer
FROM taxpayer AS t
JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY f.year_id
ORDER BY f.year_id DESC;

# REAL-WORLD TAXATION ANALYSIS
-- Task 1: Identify the income category that generates the highest total income.
SELECT c.category_name,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id
ORDER BY total_income DESC
LIMIT 1;

-- Task 2: Identify the financial year having the highest total recorded income.
SELECT f.year_label,SUM(i.amount) AS total_income
FROM income_record AS i
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY i.year_id
ORDER BY total_income DESC
LIMIT 1;

-- Task 3: Identify the income category having the highest average income.
SELECT c.category_name,(AVG(i.amount)) AS highest_avg_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id
ORDER BY highest_avg_income DESC
LIMIT 1;

-- Task 4: Display income categories having more than two income records
SELECT c.category_name, COUNT(i.category_id) AS records_count
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id 
HAVING records_count > 2;

-- Task 5: Display financial years having total income greater than ₹10,00,000.
SELECT f.year_label, SUM(i.amount) AS total_income
FROM income_record AS i
JOIN financial_year AS f
ON i.year_id = f.year_id
GROUP BY i.year_id
HAVING total_income > 1000000;

-- Task 6: Generate a summary report containing Income Category, Number of Records, Total Income, Average Income, Highest Income, and Lowest Income
SELECT c.category_name,
       COUNT(i.income_id) AS number_of_records,
       SUM(i.amount) AS total_income,
       AVG(i.amount) AS average_income,
       MAX(i.amount) AS highest_income,
       MIN(i.amount) AS lowest_income
FROM income_record AS i
JOIN income_category AS c
ON i.category_id = c.category_id
GROUP BY i.category_id;
