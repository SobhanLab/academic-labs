create database labmid2;
use labmid2;

create table STUDENT(
Student_ID int primary key not null,
Name varchar(50),
Department varchar(50),
CGPA numeric(3,2),
Admission_Year int
);

insert into STUDENT(Student_ID,Name,Department,CGPA,Admission_Year)values
(101,'Rafiq','CSE',3.75,2021),
(102,'Nabila','EEE',3.60,2020),
(103,'Hasan','CSE',3.90,2019),
(104,'Tania','BBA',3.40,2022),
(105,'Reza','EEE',3.10,2021);

create table COURSE(
Course_ID varchar(10) primary key not null,
Course_Name varchar(50),
Credit int,
Instructor varchar(100),
Department varchar(50)
);

insert into COURSE(Course_ID,Course_Name,Credit,Instructor,Department)values
('C101','Database Systems',3,'Dr.Karim','CSE'),
('C102','Circuit Theory',3,'Dr.Rahman','EEE'),
('C103','Marketing Basics',2,'Dr.Jahan','BBA'),
('C104','Computer Networks',3,'Dr.Alam','CSE'),
('C105','Control Systems',3,'Dr.Rahman','EEE');

--1
select Department, max(cgpa) as Highest_CGPA from student
group by department

--2
Select Distinct Instructor as Unique_Names From Course
Where Credit > 2

--4
Select Instructor, sum(credit) as Total_CH from Course
group by Instructor