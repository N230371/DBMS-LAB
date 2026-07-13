# PART A - DATABASE CREATION

CREATE DATABASE taxation_db;
USE taxation_db;


# PART B - TABLE CREATION USING DDL

CREATE TABLE Taxpayer(
	taxpayer_id INT PRIMARY KEY,
    pan_number VARCHAR(10) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    occupation VARCHAR(50) NOT NULL,
    annual_income DECIMAL(12,2) NOT NULL,
    email VARCHAR(100) UNIQUE,
    is_active BOOLEAN
);

CREATE TABLE Income_Category(
	category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(200) NOT NULL,
    taxable BOOLEAN NOT NULL
);

CREATE TABLE Financial_Year(
	year_id INT PRIMARY KEY,
    year_label VARCHAR(9) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    filing_deadline DATE,
    is_current BOOLEAN NOT NULL
);

CREATE TABLE Income_Record(
	income_id INT PRIMARY KEY,
    taxpayer_id INT NOT NULL,
    income_source VARCHAR(100) NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    received_date DATE NOT NULL,
    financial_year VARCHAR(9) NOT NULL
);


# PART C - DATA INSERTION USING DML

INSERT INTO Taxpayer
(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
VALUES
(101,"ABCDE1234F", "Ravi Kumar","1995-06-15","Software Engineer",850000.00,"ravi.kumar@example.com",TRUE),
(102,"BCDEF2345G","Priya Sharma","1992-11-22","Doctor",120000.00,"priya.sharma@example.com",TRUE),
(103,"cdefg3456h","Arjun Reddy","1988-03-10","Bussiness Owner",180000.00,"arjun.reddy@example.com",TRUE),
(104,"DEFGH4567J","Sneha Patel","1988-08-05","Teacher",620000.00,"sneha.patel.example.com",TRUE),
(105,"EFGHJ5678K","Kiran Rao","1990-01-18","Freelancer",750000.00,"kiran.rao@example.com",TRUE),
(106,"FGHJK6789L","Meera Singh","1985-12-30","Consultant",150000.00,"meera.singh@example.com",FALSE);

INSERT INTO Income_Category 
(category_id,category_name,description,taxable)
VALUES
(1,"Salary","Income receives from employment",TRUE),
(2,"Bussiness","Income earned from business activities",TRUE),
(3,"House Property", "Income recived from property or rent",TRUE),
(4,"Capital Gains","Income from transfer of eligible assests",TRUE),
(5,"Other Sources" ,"Income such as bank interest",TRUE),
(6,"Agricultural Income","Incomefrom eligible agricultural activities",FALSE);

INSERT INTO Financial_Year 
(year_id,year_label,start_date,end_date,filing_deadline,is_current)
VALUES
(1,"2020-2021","2020-04-01","2021-03-31","2021-07-31",FALSE),
(2,"2021-2022","2021-04-01","2022-03-31","2022-07-31",FALSE),
(3,"2022-2023","2022-04-01","2023-03-31","2023-07-31",FALSE),
(4,"2023-2024","2023-04-01","2024-03-31","2023-07-31",FALSE),
(5,"2024-2025","2024-04-01","2025-03-31","2025-07-31",FALSE),
(6,"2025-2026","2025-04-01","2026-03-31","2026-07-31",TRUE);

INSERT INTO Income_Record 
(income_id,taxpayer_id,income_source,category_name,amount, received_date,financial_year)
VALUES
(1001,101,"TechNova Sloutions","Salary",850000.00,"2026-03-31","2025-2026"),
(1002,102,"City Care Hospital","Salary",1200000.00,"2026-03-31","2025-2026"),
(1003,103,"Reddy Enterprises","Business",1800000.00,"2026-03-31","2025-2026"),
(1004,104,"Sunrise School","Salary",620000.00,"2026-03-31","2025-2026"),
(1005,105,"Web Design Projects","Business",750000.00,"2026-03-31","2025-2026"),
(1006,106,"Professional Consulting","Business",1500000.00,"2026-03-31","2025-2026");


# PART D - DML TASKS

# INSERT
INSERT INTO Taxpayer
(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
VALUES
(107,"GHJKL789M", "Rajani Kumar","1995-11-30","Software Engineer",850000.00,"rajani.kumar@example.com",TRUE);

# UPDATE
UPDATE Taxpayer
SET annual_income = 950000.00
WHERE taxpayer_id =101;

# UPDATE
UPDATE Income_Record
SET amount = 950000.00
WHERE income_id = 1001;

# UPDATE
UPDATE Taxpayer
SET occupation = "Software Consultant"
WHERE taxpayer_id =105;

# UPDATE
UPDATE Taxpayer
SET is_active = TRUE
WHERE taxpayer_id =106;

# DELETE
DELETE FROM Taxpayer
WHERE taxpayer_id =107;

#INSERT
INSERT INTO Income_Category 
(category_id,category_name,description,taxable)
VALUES
(7,"Rental Income","Income receives from tenants",TRUE);


# PART E - DDL MODIFICATION TASKS

# TASK 1: ADD A NEW COLUMN
ALTER TABLE Taxpayer
ADD COLUMN phone_number VARCHAR(15);

# TASK 2: ADD A ANOTHER COLUMN
ALTER TABLE Income_Record
ADD COLUMN remarks VARCHAR(200);

# TASK 3: MODIFY A CLOUMN
ALTER TABLE TaxPayer
MODIFY COLUMN occupation VARCHAR(150);

# TASK 4: CREATE TEMPORARY TABLE
CREATE TABLE Tax_Office(
	office_id INT PRIMARY KEY,
    office_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

# INSERT VALUES
INSERT INTO Tax_Office 
(office_id, office_name,city)
VALUES
(1234,"Intel","Benguluru"),
(2345,"Amazon","Hyderabad");

# TRUNCATE THE TABLE
TRUNCATE Tax_Office;

# DELETE THE TABLE
DROP TABLE Tax_Office;

# PART F - CONSTRAINT OBSERVATION TASKS

#1.
INSERT INTO Taxpayer
(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
VALUES
(101,"ABCDE1234F", "Ravi Kumar","1995-06-15","Software Engineer",850000.00,"ravi.kumar@example.com",TRUE);
## The error occured is duplicate primary key. This occur because the for the taxpayer_id the constriant is PRIMARY KEY which means this field should be unique and not null.

#2.
INSERT INTO Taxpayer
(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
VALUES
(107,"ABCDE1234F", "Ravi Kumar","1995-06-15","Software Engineer",850000.00,"ravi.kumar@example.com",TRUE);
## The error occured is duplicate unique key. This occured because of the contriant for the pan_number which is the unique. UNIQUE means this column should not contian the duplicate and must be unique.

#3.
INSERT INTO Taxpayer
(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
VALUES
(107,"ABCDE1204F",NULL ,"1995-06-15","Software Engineer",850000.00,"rawei.kumar@example.com",TRUE);
## The error occured is the column full_name cannot be null. This occured becaused we have used the the NOT NULL contraint for this field.


SELECT * FROM Income_Record;












