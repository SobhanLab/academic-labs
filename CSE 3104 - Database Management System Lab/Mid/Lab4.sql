create database lab4;
use lab4;

-- Create Table
CREATE TABLE e (

    e_name VARCHAR(100),

    salary_bdt INT,

    joining_date DATETIME

);


-- Insert Data
INSERT INTO e VALUES
('Rahim Ahmed', 50000, '2023-01-15 09:30:00'),
('Abid Hasan', 60000, '2022-06-20 10:00:00'),
('Sadik Khan', 55000, '2024-03-10 08:45:00');

-- Display with Currency Conversion
SELECT

    e_name,

    salary_bdt,

    (salary_bdt / 123) AS salary_usd,

    joining_date

FROM e;

-- ISDATE
SELECT ISDATE('2026-02-22') AS ValidDate;

-- DAY
SELECT DAY('2026-02-22') AS DayNumber;

-- GETDATE
SELECT GETDATE() AS CurrentDateTime;

-- CURRENT_TIMESTAMP
SELECT CURRENT_TIMESTAMP;

-- SYSDATETIME
SELECT SYSDATETIME() AS HighPrecisionDateTime;

-- GETUTCDATE
SELECT GETUTCDATE() AS CurrentUTCDateTime;

-- DATEADD
SELECT DATEADD(DAY, 5, GETDATE()) AS AfterFiveDays;

-- DATEDIFF
SELECT DATEDIFF(DAY, '2026-02-01', '2026-02-22') AS DaysDifference;

-- DATEPART
SELECT DATEPART(month, '2017/08/25') AS DatePartInt;

-- CAST
SELECT CAST(25.65 AS int);

-- CONVERT
SELECT CONVERT(int, 25.65);

SELECT STD, NAME, (CT1 + CT2 + CT3) / 3 AS Average
FROM tableCT;     -- table CT banate hobe