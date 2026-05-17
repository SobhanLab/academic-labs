create database final_t;
use final_t;

CREATE TABLE Student_Details
(
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(50)
);

INSERT INTO Student_Details
VALUES
(101, 'Sadia', 'Dhaka'),
(102, 'Nusrat', 'Khulna'),
(103, 'Kamal', 'Rajshahi'),
(104, 'Jony', 'Dhaka');

CREATE TABLE Student_Marks
(
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(50),
    CGPA DECIMAL(3,2),
    Age INT
);

INSERT INTO Student_Marks
VALUES
(101, 'Sadia', 3.99, 19),
(102, 'Nusrat', 3.20, 21),
(103, 'Kamal', 3.56, 18),
(104, 'Jony', 3.75, 20),
(105, 'Amit', 3.01, 18);

--1
create view student_view as
select d.Student_ID, d.Name, m.CGPA, d. address from student_details d
join student_marks m on d.student_ID=M.student_id

select * from student_view

--3
create procedure student_city
@adress varchar(50)
as
begin
select * from Student_Details
where address=@adress
end;

exec student_city 'Dhaka'