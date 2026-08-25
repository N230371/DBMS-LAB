USE taxation_db;

# PART A - BASIC SUBQUERIES
# LEVEL 1

-- TASK 1: Display the income record having highest income.
SELECT *
FROM income_record
WHERE amount = (
	SELECT MAX(amount)
    FROM income_record
);

-- TASK2: Display the income record having the lowest income.
SELECT *
FROM income_record
WHERE amount  = (
	SELECT MIN(amount)
    FROM income_record
);

-- TASK 3: Display income record having greater than the average income
SELECT *
FROM income_record
WHERE amount > (
	SELECT AVG(amount)
    FROM income_record
);

-- TASK 4: Display income recods having an income equal to the highest income record.
SELECT *
FROM income_record
WHERE amount = (
	SELECT MAX(amount)
    FROM income_record
);

-- TASK 5: Display taxpayers whose occupation is Business owner.
SELECT taxpayer_id, full_name 
FROM taxpayer
WHERE occupation IN (
	SELECT occupation 
    FROM taxpayer
    WHERE occupation = "Bussiness Owner"
);

# LEVEL 2 - APPLICATION
-- TASK1: Display taxpayer who have at least one income record.
SELECT taxpayer_id, full_name
FROM taxpayer
WHERE taxpayer_id = ANY (
	SELECT taxpayer_id 
    FROM income_record
    );

-- TASK2: Display taxpayer who have income in the Business category.
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
    
-- TASK3: Display income record belonging to the financial year 2025-2026.
SELECT *
FROM income_record
WHERE year_id IN (
	SELECT year_id
    FROM financial_year
    WHERE year_label = '2025-2026'
    );
    
-- TASK4: Display income records whose amount is greater than the minimum business income.
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

-- TASK5: Display income records whose amount is less than the maximum salary income
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

-- TASK6: display taxpayers who have income records greater than the average income.
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

-- TASK7: Display income category that have at least one income record
SELECT category_name
FROM income_category
WHERE category_id = ANY (
	SELECT category_id 
    FROM income_record
);

-- TASK 8: Display taxpayer who have no income records in the investment category
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
-- TASK 1: Display the taxpayer having the highest recorded income.
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

-- TASK2: Display all income records having an amount greater than the average Business income
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
    
-- TASK 3: Display taxpayers whose income is greater than the average income of all taxpayers.
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
    
-- TASK 4: Display income records having an amount greater than ANY income record under the investment category.
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
    
-- TASK 5: Display income records having an amount greater than ALL income record under the investment category.
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
    
-- TASK 6: Display the income category that contains the highest income record
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
    
-- TASK 7: Display the financial year having the highest total income.
SELECT year_label
FROM financial_year
WHERE year_id = (
	SELECT year_id
    FROM income_record
	GROUP BY year_id
    ORDER BY SUM(amount) DESC 
    LIMIT 1
    );
    
-- TASK8:  Display the taxpayer whose total recorded income is greater than the average total income of taxpayers.
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
    
-- TASK4: INdentify taxpayers who have business income but no investment income.
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
SELECT * 
FROM income_record ir
WHERE amount > (
	SELECT AVG(ir2.amount)
    FROM income_record ir2
    WHERE ir2.category_id = ir.category_id
	);















