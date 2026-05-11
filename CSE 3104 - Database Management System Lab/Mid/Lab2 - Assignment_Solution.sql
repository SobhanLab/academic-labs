-- Create Database
Create Database Lab2;
use Lab2;


-- Create Table
Create Table Worker
(
    Worker_ID int Primary Key Not Null,
    First_Name varchar(30) unique,
    Last_Name varchar(30),
    Salary int,
    Dept_Name varchar(10),
    Joining_Date datetime,

    Check(Salary > 100)
);


-- Multiple Data Insertion
insert into Worker
(Worker_ID, First_Name, Last_Name, Salary, Dept_Name, Joining_Date)

Values
(1, 'Rana', 'Hamid', 100000, 'HR', '2014-02-20 09:00:00'),
(2, 'Sanjoy', 'Saha', 80000, 'Admin', '2014-06-11 09:00:00'),
(3, 'Mahmudul', 'Hasan', 300000, 'HR', '2014-02-20 09:00:00'),
(4, 'Asad', 'Zaman', 500000, 'Admin', '2014-02-20 09:00:00'),
(5, 'Sajib', 'Mia', 500000, 'Admin', '2014-06-11 09:00:00'),
(6, 'Alamgir', 'Kabir', 200000, 'Account', '2014-06-11 09:00:00'),
(7, 'Foridul', 'Islam', 75000, 'Account', '2014-01-20 09:00:00'),
(8, 'Keshob', 'Ray', 90000, 'Admin', '2014-04-11 09:00:00');

-- 1. Display all information of Worker table
Select * from Worker;


-- 2 & 3. Display first 5 employees with FULL_NAME
Select TOP 5
Name = concat(First_Name,' ', Last_Name)
from Worker;


-- 4. Display complete record of employees working in Admin Department
Select * from Worker
where Dept_Name = 'Admin';


-- 5. Find employees whose salary is greater than 10000
Select First_Name, Salary
from Worker
where Salary > 10000;


-- 6. Find employees whose salary is greater than Sanjoy
Select First_Name, Salary
from Worker
where Salary >
(
    Select Salary
    from Worker
    where First_Name = 'Sanjoy'
);


-- 7. Update salary of Worker by 95000 whose ID is 8
Update Worker
SET Salary = 95000
where Worker_ID = 8;


-- 8. Delete record of employee whose FIRST_NAME is Asad
Delete from Worker
where First_Name = 'Asad';


-- Final Output
Select * from Worker;