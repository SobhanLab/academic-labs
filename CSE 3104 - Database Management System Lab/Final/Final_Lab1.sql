CREATE DATABASE SchoolDB;
USE SchoolDB;
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    age INT
);
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    teacher VARCHAR(50)
);
CREATE TABLE Enrollment (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
INSERT INTO Students VALUES
(1, 'Rahim', 'CSE', 20),
(2, 'Karim', 'EEE', 21),
(3, 'Amina', 'CSE', 22);

INSERT INTO Courses VALUES
(101, 'Database Systems', 'Dr. Hasan'),
(102, 'Networking', 'Dr. Ali');

INSERT INTO Enrollment VALUES
(1, 1, 101, 'A'),
(2, 2, 102, 'B'),
(3, 3, 101, 'A');
select * from Students
select * from Courses
select * from Enrollment
--Creating a view
Create view CSE_STUDENTS AS
Select student_id from Students where
department = 'CSE';

Select * from CSE_STUDENTS;

--Check option 
Create View  Teacher_Course AS
Select * from Courses 
where teacher = 'Dr. Ali'
with check option

Create view Students_view as 
Select * from students 
where age >= 18
with check option
--update view
Update Students_view 
set age = 22
where student_id = 1;
--delete view
Select * from Students_view
 delete from Students_view 
 where student_id = 1;
-- drop view
 drop view Students_view

-- index view 
Create view Students_view 
with schemabinding 
as select Students.student_id, department, grade 
from dbo.Students join dbo.Enrollment 
on Students.student_id = Enrollment.student_id

Create UNIQUE Clustered INDEX indx_STU 
on  Students_view (student_id)