create database Lab1;
use Lab1;

create table S_info(
    student_id int,
    student_name varchar(30),
    student_dept varchar(5)
)

-- Single Row Insertion
insert into S_info values(241311069, 'Sobhan', 'CSE');
insert into S_info values(241311070, 'SAS', 'CSE');
insert into S_info values(241311071, 'Daniel', 'CSE');

-- Multiple Row Insertion
insert into S_info
values (69, 'AS', 'CSE'),
       (70, 'SAS', 'CSE'),
       (71, 'DR', 'CSE');

select * from S_info;   -- output of table
drop table S_info;      -- for delete table