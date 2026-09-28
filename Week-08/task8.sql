SHOW TABLES;
SELECT * FROM taxpayer;
SELECT * FROM income_category;
SELECT * FROM financial_year;
SELECT * FROM income_record;

SET @income1 = (
    SELECT income_id
    FROM income_record
    ORDER BY income_id
    LIMIT 1
);

SET @income2 = (
    SELECT income_id
    FROM income_record
    ORDER BY income_id
    LIMIT 1 OFFSET 1
);

SET @income3 = (
    SELECT income_id
    FROM income_record
    ORDER BY income_id
    LIMIT 1 OFFSET 2
);

SET @taxpayer1 = (
    SELECT taxpayer_id
    FROM income_record
    WHERE income_id = @income1
);

SET @category1 = (
    SELECT category_id
    FROM income_record
    WHERE income_id = @income1
);

SET @year1 = (
    SELECT year_id
    FROM income_record
    WHERE income_id = @income1
);

SET @taxpayer2 = COALESCE(
    (
        SELECT taxpayer_id
        FROM income_record
        WHERE taxpayer_id <> @taxpayer1
        ORDER BY income_id
        LIMIT 1
    ),
    @taxpayer1
);

SET @new_income1 = (
    SELECT COALESCE(MAX(income_id), 0) + 1
    FROM income_record
);

SET @new_income2 = @new_income1 + 1;

SET @new_income3 = @new_income1 + 2;

SET @new_income4 = @new_income1 + 3;

SET @new_income5 = @new_income1 + 4;

SET @new_income6 = @new_income1 + 5;

SET @new_income7 = @new_income1 + 6;

SET @new_income8 = @new_income1 + 7;

SET @new_income9 = @new_income1 + 8;

SET @new_income10 = @new_income1 + 9;

SELECT
    @income1 AS first_existing_income,
    @income2 AS second_existing_income,
    @income3 AS third_existing_income,
    @taxpayer1 AS valid_taxpayer_id,
    @taxpayer2 AS second_taxpayer_id,
    @category1 AS valid_category_id,
    @year1 AS valid_year_id;


-- ============================================================
-- PART B – TCL: BASIC TRANSACTIONS
-- ============================================================

SET AUTOCOMMIT = 0;

SELECT @@AUTOCOMMIT;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id = @income1;

ROLLBACK;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 2000
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id = @income1;

COMMIT;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 50000
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id = @income1;

ROLLBACK;

SELECT *
FROM income_record
WHERE income_id = @income1;

START TRANSACTION;

INSERT INTO income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
SELECT
    @new_income1,
    taxpayer_id,
    'TCL Test Income',
    600000,
    CURRENT_DATE,
    'Rollback test',
    category_id,
    year_id
FROM income_record
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id = @new_income1;

ROLLBACK;

SELECT *
FROM income_record
WHERE income_id = @new_income1;

START TRANSACTION;

DELETE FROM income_record
WHERE income_id = @income2;

SELECT *
FROM income_record
WHERE income_id = @income2;

ROLLBACK;

SELECT *
FROM income_record
WHERE income_id = @income2;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 3000
WHERE income_id = @income1;

INSERT INTO income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
SELECT
    @new_income2,
    taxpayer_id,
    'Combined Test Income',
    700000,
    CURRENT_DATE,
    'Commit test',
    category_id,
    year_id
FROM income_record
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id IN (@income1, @new_income2);

COMMIT;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 5000
WHERE income_id = @income1;

SAVEPOINT income_update;

UPDATE income_record
SET amount = amount + 10000
WHERE income_id = @income2;

SELECT *
FROM income_record
WHERE income_id IN (@income1, @income2);

ROLLBACK TO SAVEPOINT income_update;

SELECT *
FROM income_record
WHERE income_id IN (@income1, @income2);

COMMIT;

START TRANSACTION;

INSERT INTO income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
SELECT
    @new_income3,
    taxpayer_id,
    'Savepoint Income',
    650000,
    CURRENT_DATE,
    'Savepoint test',
    category_id,
    year_id
FROM income_record
WHERE income_id = @income1;

SAVEPOINT before_update;

UPDATE income_record
SET amount = amount + 25000
WHERE income_id = @income2;

ROLLBACK TO SAVEPOINT before_update;

SELECT *
FROM income_record
WHERE income_id = @new_income3;

SELECT *
FROM income_record
WHERE income_id = @income2;

COMMIT;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = @income1;

SAVEPOINT sp1;

UPDATE income_record
SET amount = amount + 2000
WHERE income_id = @income2;

SAVEPOINT sp2;

UPDATE income_record
SET amount = amount + 3000
WHERE income_id = @income3;

ROLLBACK TO SAVEPOINT sp1;

SELECT *
FROM income_record
WHERE income_id IN
(@income1, @income2, @income3);

COMMIT;

START TRANSACTION;

-- INSERT
INSERT INTO income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
SELECT
    @new_income4,
    taxpayer_id,
    'Integrated Income',
    500000,
    CURRENT_DATE,
    'Integrated test',
    category_id,
    year_id
FROM income_record
WHERE income_id = @income1;

-- UPDATE
UPDATE income_record
SET amount = amount + 4000
WHERE income_id = @income1;

-- SAVEPOINT before DELETE
SAVEPOINT before_delete;

-- DELETE
DELETE FROM income_record
WHERE income_id = @income2;

-- ROLLBACK DELETE
ROLLBACK TO SAVEPOINT before_delete;

COMMIT;

SELECT *
FROM income_record
WHERE income_id IN
(@income1, @income2, @new_income4);

START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = @income1;

SAVEPOINT income_update;

RELEASE SAVEPOINT income_update;

ROLLBACK;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = @income1;

SAVEPOINT sp_difference;

UPDATE income_record
SET amount = amount + 2000
WHERE income_id = @income2;

ROLLBACK TO SAVEPOINT sp_difference;

SELECT *
FROM income_record
WHERE income_id IN (@income1, @income2);

COMMIT;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = @income1;

UPDATE income_record
SET amount = amount + 2000
WHERE income_id = @income2;

ROLLBACK;

DROP USER IF EXISTS 'tax_clerk1'@'localhost';

CREATE USER 'tax_clerk1'@'localhost'
IDENTIFIED BY 'Tax@123';

SELECT User, Host
FROM mysql.user
WHERE User = 'tax_clerk1';

GRANT SELECT
ON taxation_db.taxpayer
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

-- TEST AS tax_clerk1
-- RUN THE FOLLOWING IN A SECOND MYSQL CONNECTION

-- SELECT CURRENT_USER();

-- SELECT *
-- FROM taxation_db.taxpayer;


GRANT INSERT
ON taxation_db.income_record
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';


-- TEST AS tax_clerk1

-- INSERT INTO taxation_db.income_record
-- (
--     income_id,
--     taxpayer_id,
--     income_source,
--     amount,
--     received_date,
--     remarks,
--     category_id,
--     year_id
-- )
-- SELECT
--     (SELECT MAX(income_id) + 1
--      FROM taxation_db.income_record),
--     taxpayer_id,
--     'DCL Test Income',
--     550000,
--     CURRENT_DATE,
--     'DCL insert',
--     category_id,
--     year_id
-- FROM taxation_db.income_record
-- LIMIT 1;

-- Run as tax_clerk1:
--
-- UPDATE taxation_db.income_record
-- SET amount = amount + 1000
-- WHERE income_id = @income1;
--
-- This should be denied.


-- ADMIN CONNECTION

CREATE OR REPLACE VIEW Taxpayer_Income_Summary AS
SELECT
    t.taxpayer_id,
    t.full_name,
    SUM(i.amount) AS total_income
FROM taxpayer t
JOIN income_record i
    ON t.taxpayer_id = i.taxpayer_id
GROUP BY
    t.taxpayer_id,
    t.full_name;

GRANT SELECT
ON taxation_db.Taxpayer_Income_Summary
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

-- TEST AS tax_clerk1


-- SELECT *
-- FROM taxation_db.Taxpayer_Income_Summary;

REVOKE INSERT
ON taxation_db.income_record
FROM 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

DROP USER IF EXISTS 'tax_data_entry'@'localhost';

CREATE USER 'tax_data_entry'@'localhost'
IDENTIFIED BY 'Entry@123';

GRANT SELECT, INSERT
ON taxation_db.income_record
TO 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

DROP USER IF EXISTS 'tax_officer'@'localhost';

CREATE USER 'tax_officer'@'localhost'
IDENTIFIED BY 'Officer@123';

GRANT SELECT, INSERT, UPDATE
ON taxation_db.income_record
TO 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

GRANT SELECT
ON taxation_db.Taxpayer_Income_Summary
TO 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

GRANT SELECT, INSERT, UPDATE
ON taxation_db.income_record
TO 'tax_officer'@'localhost';

REVOKE UPDATE
ON taxation_db.income_record
FROM 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

DROP USER IF EXISTS 'minimum_entry'@'localhost';

CREATE USER 'minimum_entry'@'localhost'
IDENTIFIED BY 'Minimum@123';

GRANT SELECT, INSERT
ON taxation_db.income_record
TO 'minimum_entry'@'localhost';

SHOW GRANTS FOR 'minimum_entry'@'localhost';

START TRANSACTION;

INSERT INTO income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
SELECT
    @new_income5,
    taxpayer_id,
    'Annual Income',
    750000,
    CURRENT_DATE,
    'Annual income test',
    category_id,
    year_id
FROM income_record
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id = @new_income5;

COMMIT;

SELECT *
FROM income_record
WHERE income_id = @new_income5;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 999999
WHERE income_id = @income1;

SELECT *
FROM income_record
WHERE income_id = @income1;

ROLLBACK;

SELECT *
FROM income_record
WHERE income_id = @income1;


START TRANSACTION;

UPDATE income_record
SET amount = amount + 5000
WHERE income_id = @income1;

SAVEPOINT valid_update;

UPDATE income_record
SET amount = amount + 999999
WHERE income_id = @income2;

ROLLBACK TO SAVEPOINT valid_update;

COMMIT;

SELECT *
FROM income_record
WHERE income_id IN (@income1, @income2);

DROP USER IF EXISTS 'tax_data_entry2'@'localhost';

CREATE USER 'tax_data_entry2'@'localhost'
IDENTIFIED BY 'Entry@456';

GRANT SELECT, INSERT
ON taxation_db.income_record
TO 'tax_data_entry2'@'localhost';

SHOW GRANTS FOR 'tax_data_entry2'@'localhost';

CREATE OR REPLACE VIEW Taxpayer_Income_Summary AS
SELECT
    t.taxpayer_id,
    t.full_name,
    SUM(i.amount) AS total_income
FROM taxpayer t
JOIN income_record i
    ON t.taxpayer_id = i.taxpayer_id
GROUP BY
    t.taxpayer_id,
    t.full_name;

GRANT SELECT
ON taxation_db.Taxpayer_Income_Summary
TO 'tax_officer'@'localhost';

SELECT *
FROM Taxpayer_Income_Summary;

GRANT DELETE
ON taxation_db.income_record
TO 'tax_data_entry2'@'localhost';

SHOW GRANTS FOR 'tax_data_entry2'@'localhost';

REVOKE DELETE
ON taxation_db.income_record
FROM 'tax_data_entry2'@'localhost';

SHOW GRANTS FOR 'tax_data_entry2'@'localhost';

USE taxation_db;

SHOW TABLES;

SELECT * FROM taxpayer;

SELECT * FROM income_category;

SELECT * FROM financial_year;

SELECT * FROM income_record;

SELECT @@AUTOCOMMIT;

SET AUTOCOMMIT = 1;

SELECT CURRENT_USER();

SHOW GRANTS FOR 'tax_clerk1'@'localhost';


-- ============================================================
-- OPTIONAL CLEANUP
-- Uncomment ONLY if you want to delete the lab users.
-- ============================================================

-- DROP USER IF EXISTS 'tax_clerk1'@'localhost';
-- DROP USER IF EXISTS 'tax_data_entry'@'localhost';
-- DROP USER IF EXISTS 'tax_officer'@'localhost';
-- DROP USER IF EXISTS 'minimum_entry'@'localhost';
-- DROP USER IF EXISTS 'tax_data_entry2'@'localhost';