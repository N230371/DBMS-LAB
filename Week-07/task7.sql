USE taxation_db;
## Part A Basic Views
# Level 1 

-- Task1:  Create a view displaying the income record having the highest income.
CREATE VIEW highest_income AS
SELECT *
FROM income_record
WHERE amount IN (
	SELECT MAX(amount)
    FROM income_record
    );
    
select * from highest_income;
    
-- Task2: Create a view displaying the income record having the lowest income.
CREATE VIEW lowest_income AS
SELECT *
FROM income_record
WHERE amount IN (
	SELECT MIN(amount)
    FROM income_record
    );
    
SELECT * FROM lowest_income;

-- Task 3: Create a view displaying income records greater than the average income.
CREATE VIEW avg_income AS
SELECT *
FROM income_record
WHERE amount > ALL (
	SELECT AVG(amount)
    FROM income_record
    );

select * from avg_income;

-- Task 4:  Create a view containing income records equal to the highest recorded income.
CREATE VIEW highest_record AS
SELECT *
FROM income_record
WHERE amount = (
	SELECT MAX(amount)
    FROM income_record
    );
    
-- Task 5:  Create a view containing taxpayers whose occupation is Business Owner.
CREATE VIEW business_owner AS
SELECT *
FROM taxpayer
WHERE occupation = "Bussiness Owner";

# Level 2:
-- Task1: Create a view displaying taxpayers who have at least one income record.
CREATE VIEW has_at_least_one_ir AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id = ANY (
	SELECT taxpayer_id 
    FROM income_record
    );

-- Task 2: Create a view displaying taxpayers who have income in the Business category.
CREATE VIEW business_category AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM income_record
    WHERE category_id = (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Bussiness'
        )
	);

-- Task 3: Create a view displaying income records belonging to the financial year 2025-2026.
CREATE VIEW fYear_2025_26 AS
SELECT *
FROM income_record
WHERE year_id IN (
	SELECT year_id
    FROM financial_year
    WHERE year_label = '2025-2026'
    );
    
CREATE VIEW finYear_2025_26 AS
SELECT *
FROM income_record
WHERE year_id IN (
	SELECT i.year_id
    FROM income_record AS i
	JOIN financial_year AS f
    ON i.year_id = f.year_id
    WHERE year_label = "2025-2026"
    );

-- Task 4: Create a view displaying income records whose amount is greater than the minimum Business income.
CREATE VIEW greater_min_bIncome AS
SELECT * 
FROM income_record
WHERE amount > (
	SELECT MIN(amount)
    FROM income_record
    WHERE category_id = (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Bussiness'
        )
	);
    
-- TASK5: Create a view displaying income records whose amount is less than the maximum Salary income
CREATE VIEW max_sal_income AS
SELECT *
FROM income_record
WHERE amount < (
	SELECT MAX(amount)
    FROM income_record
    WHERE category_id = (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Salary'
        )
	);

-- TASK6: Create a view displaying taxpayers who have income records greater than the average income.
CREATE VIEW greater_avg_income AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
	FROM income_record
	WHERE amount > (
		SELECT AVG(amount)
		FROM income_record
    )
);

-- TASK7: Create a view displaying income categories that have at least one income record.
CREATE VIEW ic_at_least_one_ir AS
SELECT category_name
FROM income_category
WHERE category_id = ANY (
	SELECT category_id 
    FROM income_record
);

-- TASK 8: Create a view displaying taxpayers who have no income records in the Investment category.
CREATE VIEW no_ir_invest_cat AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id NOT IN (
	SELECT taxpayer_id 
    FROM income_record
    WHERE category_id IN (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Investment'
        )
	);
    
# LEVEL 3
-- TASK 1: Create a view displaying the taxpayer having the highest recorded income.
CREATE VIEW taxpayer_high_ir AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM income_record
    WHERE amount = (
		SELECT MAX(amount)
        FROM income_record
        )
	);

-- TASK2:Create a view displaying all income records having an amount greater than the average Business income.
CREATE VIEW ir_greatAmount_avg_bIncome AS
SELECT *
FROM income_record
WHERE amount > (
	SELECT AVG(amount)
	FROM income_record
	WHERE category_id = (
		SELECT category_id
		FROM income_category
		WHERE category_name = 'Bussiness'
		)
	);
    
-- TASK 3: Create a view displaying taxpayers whose total income is greater than the average total income of all taxpayers.
CREATE VIEW payer_tIncome_greater_avg_tIncome AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM taxpayer
    WHERE annual_income > (
		SELECT AVG(annual_income)
        FROM taxpayer
        )
	);
    
-- TASK 4:  Create a view displaying income records having an amount greater than at least one Investment income record.
CREATE VIEW ir_amt_greater_at_least_one_investRecord AS
SELECT *
FROM income_record
WHERE amount > ANY (
	SELECT amount 
    FROM income_record
    WHERE category_id IN (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Investment'
        )
	);
    
-- TASK 5:Create a view displaying income records having an amount greater than every Investment income record.
CREATE VIEW ir_great_all_invest_record AS
SELECT *
FROM income_record
WHERE amount > ALL (
	SELECT amount 
    FROM income_record
    WHERE category_id IN (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Investment'
        )
	);
    
-- TASK 6: Create a view displaying the income category that contains the highest income record.
CREATE VIEW ic_highest_ir AS
SELECT category_name
FROM income_category
WHERE category_id IN (
	SELECT category_id
    FROM income_record
    WHERE amount = (
		SELECT MAX(amount)
        FROM income_record
		)
	);
    
-- TASK 7: Create a view displaying the financial year having the highest total income.
CREATE VIEW finYear_highest_inc AS
SELECT year_label
FROM financial_year
WHERE year_id = (
	SELECT year_id
    FROM income_record
	GROUP BY year_id
    ORDER BY SUM(amount) DESC 
    LIMIT 1
    );
    
-- TASK8: Create a view displaying taxpayers whose total recorded income is greater than the average total income of taxpayers.
CREATE VIEW payer_ir_great_avg_tIncome AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM income_record
    GROUP BY taxpayer_id
    HAVING SUM(amount) > (
		SELECT AVG(total_income)
        FROM (
			SELECT taxpayer_id, SUM(amount) AS total_income
            FROM income_record
            GROUP BY taxpayer_id
            ) AS taxpayer_totals
		)
	);
    
## Real-world Taxation analysis
-- TASK 1: Identify the taxpayer who has the highest individual income
CREATE VIEW payer_highest_income AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id 
    FROM income_record 
    WHERE amount = (
		SELECT MAX(amount)
        FROM income_record
        )
	);

-- TASK 2: Identify taxpayers whose income is above the overall average income.
CREATE VIEW payer_inc_above_avg_inc AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM income_record
    WHERE amount > (
		SELECT AVG(amount)
        FROM income_record
		)
	);
    
-- TASK3: Identify the income category containing the highest income record.
CREATE VIEW ic_high_ir AS
SELECT category_name
FROM income_category
WHERE category_id IN (
	SELECT category_id
    FROM income_record
    WHERE amount = (
		SELECT MAX(amount)
        FROM income_record
        )
	);
    
-- TASK4: Indentify taxpayers who have business income but no investment income.
CREATE VIEW payer_with_bInc_not_invest_inc AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM income_record
    WHERE category_id IN (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Bussiness'
        )
	)
    AND taxpayer_id NOT IN (
		SELECT taxpayer_id
        FROM income_record
        WHERE category_id IN (
			SELECT category_id
            FROM income_category
            WHERE category_name = 'Investment'
            )
		);
    
-- task5: Identify income records whose amount is greater than every Investment income record.
CREATE VIEW ir_amt_greater_all_invest_ir AS
SELECT *
FROM income_record
WHERE amount > ALL (
	SELECT amount
    FROM income_record
    WHERE category_id IN (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Investment'
        )
	);

-- TASK6: Identify income records whose amount is greater than at least one Investment income record
CREATE VIEW ir_amt_greater_any_invest_ir AS
SELECT *
FROM income_record
WHERE amount > ANY (
	SELECT amount
    FROM income_record
    WHERE category_id IN (
		SELECT category_id
        FROM income_category
        WHERE category_name = 'Investment'
        )
	);

-- TASK7: Display the taxpayer having the highest total income.
CREATE VIEW payer_highest_inc AS
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id IN (
	SELECT taxpayer_id
    FROM income_record
    GROUP BY taxpayer_id
    HAVING SUM(amount) = (
		SELECT MAX(total_income) 
        FROM (
			SELECT taxpayer_id, SUM(amount) AS total_income 
            FROM income_record
            GROUP BY taxpayer_id
            ) AS totals
		)
	);
    
-- task8: Generate a list of income records whose amount is above the average income of their corresponding category.
CREATE VIEW ir_greater_avg_inc_corres_cat AS
SELECT * 
FROM income_record ir
WHERE amount > (
	SELECT AVG(ir2.amount)
    FROM income_record ir2
    WHERE ir2.category_id = ir.category_id
	);


