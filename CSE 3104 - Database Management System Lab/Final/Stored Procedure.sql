create database twelve;
use twelve;

Create Table Student(
Student_id int primary key not null, 
name varchar (50), 
department varchar(30), 
cgpa decimal(3,2) 
); 
insert into Student Values 
(1, 'Rahim', 'CSE', 3.78),
(2, 'Asha', 'EEE', 3.85),
(3, 'Karim', 'CSE', 3.40), 
(4, 'Nusrat', 'BBA', 3.65), 
(5, 'Sadia', 'BBA', 3.90);
 
 select * from Student;

 --store procedure.
 create procedure student_procedure
 AS
 BEGIN
 SELECT * FROM Student
 END

EXEC student_procedure;

select*from Student
where Student_id=1;

create procedure student_pro
    @id int
as
begin
select  * from Student
where Student_id=@id
end
EXEC student_pro 2;

create procedure stu_name_cgpa
 @name varchar (50),
 @cgpa decimal(3,2)
 as
begin
select  * from Student
where name=@name and cgpa=@cgpa
end

EXEC stu_name_cgpa 'karim',3.40;
EXEC stu_name_cgpa 'Asha',3.85;

--Insert.
create procedure insert_student
@id int,
@name varchar (50), 
@department varchar(30), 
@cgpa decimal(3,2)

as 
begin 
insert into Student values
(@id,@name,@department,@cgpa)
end
EXEC  insert_student 6,'Prottoy','YYY',3.99
SELECT*FROM Student

--Update.

create procedure update_student
@id int,  
@cgpa decimal(3,2)

as 
begin 
update Student
set cgpa=@cgpa
where Student_id=@id
end

EXEC  update_student 2,4.00
select*from Student

--Delete.
create procedure delete_STD
@name varchar(50)
AS
BEGIN
delete from Student
where name =@name
END

EXEC delete_STD 'Asha'
select * from Student
--output shows.
create procedure studentcout
@total int output
as 
Begin 
 select @total = count(student_id)
 from Student
End

declare @result int
exec studentcout @result output
print @result

--Alter.
 Alter Procedure Stu_Name_cgpa 
   @name varchar(50)
   AS 
   Begin 
     Select * from Student 
where Name = @name
   END 
 
   EXEC Stu_Name_cgpa Asha
 select *from Student

 Alter  Procedure Stu_Name_cgpa 
    @name varchar (50), 
    @cgpa decimal(3,2)
AS 
Begin
Select * from Student 
where Name = @name AND cgpa = @cgpa order by name 
End 
 
EXEC Stu_Name_cgpa 'sadia', 3.90

select*from Student


-- System stored Procedure 
EXEC prac5_help
--- To know about a particular procedure 
EXEC prac5-help Student