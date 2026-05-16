create database Practice_Store_Procedure; -- Create database
use Practice_Store_Procedure; -- Select database

CREATE TABLE Account_Detail -- Create Account_Detail table
(
    Account_no INT PRIMARY KEY, -- Primary Key
    Acc_holder_name VARCHAR(50), -- Account holder name
    Amount INT, -- Amount column
    Branch_Id VARCHAR(10), -- Branch ID
    Zone_Id VARCHAR(10) -- Zone ID
);


INSERT INTO Account_Detail -- Insert data into Account_Detail
VALUES
(1992212, 'Mr. Nazmuzzaman', 200000, 'B-101', 'Z-803'),
(1992213, 'Mr. Jibon', 170000, 'B-102', 'Z-803'),
(1882212, 'Bushra', 180000, 'B-103', 'Z-802'),
(1882213, '%Sajib', 170000, 'B-104', 'Z-801');


CREATE TABLE Branch -- Create Branch table
(
    Br_Id VARCHAR(10) PRIMARY KEY, -- Primary Key
    Branch_Name VARCHAR(50) -- Branch name
);


INSERT INTO Branch -- Insert data into Branch table
VALUES
('B-101', 'Bonani'),
('B-102', 'Romna'),
('B-103', 'Shaheb bazar'),
('B-104', 'Ullapara');


CREATE TABLE ZoneInfo -- Create ZoneInfo table
(
    Zone_Id VARCHAR(10) PRIMARY KEY, -- Primary Key
    Name VARCHAR(50) -- Zone name
);


INSERT INTO ZoneInfo -- Insert data into ZoneInfo table
VALUES
('Z-801', 'Sirajgonj'),
('Z-802', 'Rajshahi'),
('Z-803', 'Dhaka'),
('Z-804', 'Chittagong');


SELECT * FROM Account_Detail; -- Show Account_Detail table
SELECT * FROM Branch; -- Show Branch table
SELECT * FROM ZoneInfo; -- Show ZoneInfo table


-- Problem 1

CREATE PROCEDURE SPdetails -- Create stored procedure
AS
BEGIN

SELECT
    Acc_holder_name, -- Show account holder name
    Amount, -- Show amount
    Branch_Name, -- Show branch name
    ZoneInfo.Name AS Zone_Name -- Rename Name as Zone_Name

FROM Account_Detail
INNER JOIN Branch -- Join Branch table
ON Account_Detail.Branch_Id = Branch.Br_Id

INNER JOIN ZoneInfo -- Join ZoneInfo table
ON Account_Detail.Zone_Id = ZoneInfo.Zone_Id

END


EXEC SPdetails; -- Execute procedure


-- Problem 2

CREATE PROCEDURE SPaverage -- Create procedure
    @amount INT -- Parameter
AS
BEGIN

SELECT
    Branch_Name, -- Show branch name
    Amount -- Show amount

FROM Account_Detail
INNER JOIN Branch -- Join Branch table
ON Account_Detail.Branch_Id = Branch.Br_Id

WHERE Amount > @amount -- Amount greater than parameter

END


EXEC SPaverage 170000; -- Execute procedure


-- Problem 3

CREATE PROCEDURE SPbalance -- Create procedure
    @zonename VARCHAR(50), -- Input parameter
    @total INT OUTPUT -- Output parameter
AS
BEGIN

SELECT @total = SUM(Amount) -- Sum total amount

FROM Account_Detail
INNER JOIN ZoneInfo -- Join ZoneInfo table
ON Account_Detail.Zone_Id = ZoneInfo.Zone_Id

WHERE ZoneInfo.Name = @zonename -- Match zone name

END


DECLARE @result INT; -- Declare variable

EXEC SPbalance 'Dhaka', @result OUTPUT; -- Execute procedure

PRINT @result; -- Print output result


-- Problem 4

CREATE PROCEDURE SPamount -- Create procedure
AS
BEGIN

SELECT
    Acc_holder_name, -- Show account holder name
    Branch_Name, -- Show branch name
    ZoneInfo.Name AS Zone_Name, -- Rename column
    Amount -- Show amount

FROM Account_Detail
INNER JOIN Branch -- Join Branch table
ON Account_Detail.Branch_Id = Branch.Br_Id

INNER JOIN ZoneInfo -- Join ZoneInfo table
ON Account_Detail.Zone_Id = ZoneInfo.Zone_Id

WHERE Acc_holder_name LIKE '%Mr.%' -- Find substring Mr.
AND Amount <
(
    SELECT MAX(Amount) -- Find maximum amount
    FROM Account_Detail
)

END


EXEC SPamount; -- Execute procedure


-- Problem 5

CREATE PROCEDURE SPdetailsInfo -- Create procedure
    @zonename VARCHAR(50), -- Input parameter
    @totalcustomer INT OUTPUT -- Output parameter
AS
BEGIN

SELECT @totalcustomer = COUNT(Account_no) -- Count customers

FROM Account_Detail
INNER JOIN ZoneInfo -- Join ZoneInfo table
ON Account_Detail.Zone_Id = ZoneInfo.Zone_Id

WHERE ZoneInfo.Name = @zonename -- Match zone name

END


DECLARE @res INT; -- Declare variable

EXEC SPdetailsInfo 'Dhaka', @res OUTPUT; -- Execute procedure

PRINT @res; -- Print output