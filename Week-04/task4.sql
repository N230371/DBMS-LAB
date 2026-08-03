USE taxation_db;
SHOW TABLES;

## PART B - SQL JOIN OPERATIONS

# LEVEL 1

# TASK-1 Display every taxpayer along with the income source using an INNER JOIN.

SELECT t.full_name, i.income_source
FROM taxpayer AS t
INNER JOIN
income_record AS i
ON
t.taxpayer_id = i.taxpayer_id;

# TASK-2 Display every taxpayer along with the category of income they earn

SELECT t.full_name, c.category_name
FROM taxpayer t
INNER JOIN Income_Record i
ON t.taxpayer_id = i.taxpayer_id

INNER JOIN Income_Category c 
ON i.category_id = c.category_id;

# Task-3 Display every income record along with its financial year.

SELECT * 
FROM income_record i
INNER JOIN financial_year f
ON i.year_id = f.year_id;

# Task-4 Display the taxpayer name together with the annual income and income amount recorded in the Income_Record table

SELECT t.full_name, t.annual_income,i.amount
FROM taxpayer t
INNER JOIN income_record i
ON i.taxpayer_id = t.taxpayer_id;

# Task-5 Display the taxpayer name, income source, category name and financial year for every income record.

SELECT t.full_name, i.income_source, c.category_name, f.year_label
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
INNER JOIN financial_year as f
ON i.year_id = f.year_id;

# LEVEL 2

# Task-1 Display all taxpayers who earn Salary income along with the organization from which they receive the income.

SELECT t.full_name, i.income_source
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
WHERE c.category_name='Salary';

# Task-2 Display all taxpayers who earn Business income together with their occupation and income source.

SELECT t.full_name, t.occupation, i.income_source
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
WHERE c.category_name='Bussiness';

# Task-3 Display taxpayer details together with the financial year start date and end date

SELECT t.*, f.start_date,f.end_date
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN financial_year AS f
ON i.year_id = f.year_id;

# Task-4 Display taxpayer details together with the description of the income category.

SELECT t.*, c.description
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id;

# Task-5 Display complete taxation information by joining Taxpayer, Income_Record, Income_Category, and Financial_Year.

SELECT t.full_name,t.pan_number,t.occupation,i.income_source,c.category_name,i.amount,f.year_label,f.start_date,f.end_date
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
INNER JOIN financial_year AS f
ON i.year_id = f.year_id;

# LEVEL 3

# Task-1 Display all taxpayers including those who have not yet submitted any income records.
 
SELECT * 
FROM taxpayer AS t
LEFT JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id;

# Task-2 Display all income categories including those that are not associated with any income records.

SELECT * 
FROM income_record AS i
RIGHT JOIN income_category AS c
ON i.category_id = c.category_id;

# Task-3 Display all taxpayers and all income records, including unmatched records from both tables.

SELECT * 
FROM taxpayer AS t
LEFT JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
UNION
SELECT * 
FROM taxpayer AS t
RIGHT JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id;

# Task-4 Generate every possible combination of taxpayers and financial years.

SELECT *
FROM taxpayer AS t
CROSS JOIN financial_year AS f;

# Task-5 Display pairs of taxpayers having the same occupation without displaying the same taxpayer twice.

SELECT t1.full_name, t2.full_name, t1.occupation
FROM taxpayer AS t1
CROSS JOIN taxpayer AS t2
WHERE (t1.occupation = t2.occupation AND t1.taxpayer_id < t2.taxpayer_id);

# Task-6 Display the taxpayer name, PAN number, income source, income category and financial year in a single query.

SELECT t.full_name,t.pan_number, i.income_source, c.category_name, f.year_label
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
INNER JOIN financial_year AS f
ON i.year_id = f.year_id;

# Task-7 Display all taxpayers together with their income category and category description.

SELECT t.full_name, c.category_name,c.description
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id;

# Task-8 Display the income source together with the financial year label.

SELECT i.income_source, f.year_label
FROM income_record AS i
INNER JOIN financial_year AS f
ON i.year_id = f.year_id;

# Task-9 Display taxpayers whose income belongs to the Business category during the financial year 2025–2026.

SELECT full_name
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
INNER JOIN financial_year AS f
ON i.year_id = f.year_id
WHERE (c.category_name = 'Bussiness' AND f.year_label = '2025-2026');

# Task-10 Display the complete taxation report containing taxpayer details, income details, category details and financial year details.

SELECT * 
FROM taxpayer AS t
INNER JOIN income_record AS i
ON t.taxpayer_id = i.taxpayer_id
INNER JOIN income_category AS c
ON i.category_id = c.category_id
INNER JOIN financial_year AS f
ON i.year_id = f.year_id;

