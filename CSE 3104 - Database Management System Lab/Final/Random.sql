CREATE DATABASE final_table; -- Create database
USE final_table; -- Select database


CREATE TABLE Student_Details -- Create Student_Details table
(
    Student_ID INT PRIMARY KEY, -- Primary Key
    Name VARCHAR(50), -- Student name
    Address VARCHAR(50) -- Address
);


INSERT INTO Student_Details -- Insert data
VALUES
(101, 'Sadia', 'Dhaka'),
(102, 'Nusrat', 'Khulna'),
(103, 'Kamal', 'Rajshahi'),
(104, 'Jony', 'Dhaka');


CREATE TABLE Student_Marks -- Create Student_Marks table
(
    Student_ID INT PRIMARY KEY, -- Primary Key
    Name VARCHAR(50), -- Student name
    CGPA DECIMAL(3,2), -- CGPA
    Age INT -- Age
);


INSERT INTO Student_Marks -- Insert data
VALUES
(101, 'Sadia', 3.99, 19),
(102, 'Nusrat', 3.20, 21),
(103, 'Kamal', 3.56, 18),
(104, 'Jony', 3.75, 20),
(105, 'Amit', 3.01, 18);


SELECT * FROM Student_Details; -- Show Student_Details table
SELECT * FROM Student_Marks; -- Show Student_Marks table



-- ============================================================
--                       TOPIC 1 : VIEW
-- ============================================================


-- Question 1
-- Create view for students from Dhaka

CREATE VIEW Dhaka_Students
AS
SELECT *
FROM Student_Details
WHERE Address = 'Dhaka';


SELECT * FROM Dhaka_Students; -- Show view



-- Question 2
-- Create view for CGPA > 3.50

CREATE VIEW HighCGPA_Students
AS
SELECT Name, CGPA
FROM Student_Marks
WHERE CGPA > 3.50;


SELECT * FROM HighCGPA_Students; -- Show view



-- Question 3
-- Create view with Student_ID, Name and CGPA

CREATE VIEW Student_Info
AS
SELECT Student_ID, Name, CGPA
FROM Student_Marks;


SELECT * FROM Student_Info; -- Show view



-- Question 4
-- Create joined view

CREATE VIEW Full_Student_Info
AS
SELECT
    Student_Details.Student_ID,
    Student_Details.Name,
    Address,
    CGPA,
    Age

FROM Student_Details
INNER JOIN Student_Marks
ON Student_Details.Student_ID = Student_Marks.Student_ID;


SELECT * FROM Full_Student_Info; -- Show joined view



-- Question 5
-- Drop view

DROP VIEW HighCGPA_Students;



-- ============================================================
--                    TOPIC 2 : INDEX
-- ============================================================


-- Question 1
-- Create normal index on Name

CREATE INDEX idx_name
ON Student_Marks(Name);



-- Question 2
-- Create index on CGPA

CREATE INDEX idx_cgpa
ON Student_Marks(CGPA);



-- Question 3
-- Create unique index on Student_ID

CREATE UNIQUE INDEX idx_student_id
ON Student_Details(Student_ID);



-- Question 4
-- Create composite index

CREATE INDEX idx_name_age
ON Student_Marks(Name, Age);



-- Question 5
-- Drop index

DROP INDEX Student_Marks.idx_name;



-- ============================================================
--               TOPIC 3 : STORED PROCEDURE
-- ============================================================


-- Question 1
-- Simple stored procedure

CREATE PROCEDURE ShowAllStudents
AS
BEGIN

    SELECT * FROM Student_Marks;

END


EXEC ShowAllStudents; -- Execute procedure



-- Question 2
-- Procedure with parameter

CREATE PROCEDURE FindStudent
    @sid INT
AS
BEGIN

    SELECT *
    FROM Student_Marks
    WHERE Student_ID = @sid;

END


EXEC FindStudent 101; -- Execute procedure



-- Question 3
-- Procedure with Name and CGPA

CREATE PROCEDURE Student_Name_CGPA
    @name VARCHAR(50),
    @cgpa DECIMAL(3,2)
AS
BEGIN

    SELECT *
    FROM Student_Marks
    WHERE Name = @name
    AND CGPA = @cgpa;

END


EXEC Student_Name_CGPA 'Sadia', 3.99;



-- Question 4
-- Procedure for CGPA greater than parameter

CREATE PROCEDURE GetByCGPA
    @min_cgpa DECIMAL(3,2)
AS
BEGIN

    SELECT Name, CGPA
    FROM Student_Marks
    WHERE CGPA >= @min_cgpa;

END


EXEC GetByCGPA 3.50;



-- Question 5
-- Insert procedure

CREATE PROCEDURE Insert_Student
    @id INT,
    @name VARCHAR(50),
    @cgpa DECIMAL(3,2),
    @age INT
AS
BEGIN

    INSERT INTO Student_Marks
    VALUES(@id, @name, @cgpa, @age);

END


EXEC Insert_Student 106, 'Rafi', 3.88, 22;

SELECT * FROM Student_Marks;



-- Question 6
-- Update procedure

CREATE PROCEDURE Update_CGPA
    @id INT,
    @newcgpa DECIMAL(3,2)
AS
BEGIN

    UPDATE Student_Marks
    SET CGPA = @newcgpa
    WHERE Student_ID = @id;

END


EXEC Update_CGPA 102, 3.90;

SELECT * FROM Student_Marks;



-- Question 7
-- Delete procedure

CREATE PROCEDURE Delete_Student
    @id INT
AS
BEGIN

    DELETE FROM Student_Marks
    WHERE Student_ID = @id;

END


EXEC Delete_Student 105;

SELECT * FROM Student_Marks;



-- Question 8
-- Output parameter procedure

CREATE PROCEDURE Student_Count
    @total INT OUTPUT
AS
BEGIN

    SELECT @total = COUNT(Student_ID)
    FROM Student_Marks;

END


DECLARE @result INT;

EXEC Student_Count @result OUTPUT;

PRINT @result;



-- Question 9
-- Alter procedure

ALTER PROCEDURE Student_Name_CGPA
    @name VARCHAR(50)
AS
BEGIN

    SELECT *
    FROM Student_Marks
    WHERE Name = @name;

END


EXEC Student_Name_CGPA 'Sadia';



-- Question 10
-- System stored procedure

EXEC sp_help Student_Marks;



-- Question 11
-- Drop procedure

DROP PROCEDURE ShowAllStudents;



-- ============================================================
--                  TOPIC 4 : CASCADING
-- ============================================================


-- IMPORTANT
-- Delete Amit because Student_Details has no 105

DELETE FROM Student_Marks
WHERE Student_ID = 105;



-- Question 1
-- Add foreign key with cascade

ALTER TABLE Student_Marks
ADD CONSTRAINT fk_student
FOREIGN KEY (Student_ID)
REFERENCES Student_Details(Student_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;



-- Question 2
-- Create Department table

CREATE TABLE Department
(
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(50)
);



INSERT INTO Department
VALUES
(1, 'CSE'),
(2, 'EEE');



-- Question 3
-- Create Students table with cascading

CREATE TABLE Students
(
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Dept_ID INT,

    FOREIGN KEY (Dept_ID)
    REFERENCES Department(Dept_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);



INSERT INTO Students
VALUES
(101, 'Sadia', 1),
(102, 'Kamal', 1),
(103, 'Jony', 2);



SELECT * FROM Department;
SELECT * FROM Students;



-- Question 4
-- Test ON UPDATE CASCADE

UPDATE Department
SET Dept_ID = 5
WHERE Dept_ID = 1;


SELECT * FROM Students;



-- Question 5
-- Test ON DELETE CASCADE

DELETE FROM Department
WHERE Dept_ID = 5;


SELECT * FROM Students;



-- Question 6
-- Create Exam_Result table with cascade

CREATE TABLE Exam_Result
(
    Result_ID INT PRIMARY KEY,
    Student_ID INT,
    Grade VARCHAR(5),

    FOREIGN KEY (Student_ID)
    REFERENCES Student_Details(Student_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);



-- Question 7
-- Drop foreign key

ALTER TABLE Student_Marks
DROP CONSTRAINT fk_student;