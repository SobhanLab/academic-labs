create database assignment_69B;
use assignment_69B;

create table Salesman
(
    Salesman_ID int primary key,
    Name varchar(50),
    City varchar(50),
    Commission decimal(4,2)
);

create table Orders
(
    Order_No int primary key,
    Purchase_amount decimal(10,2),
    Order_Date date,
    Customer_ID int,
    Salesman_ID int,
    foreign key(Salesman_ID)
    references Salesman(Salesman_ID)
);

insert into Salesman values
(5001,'James Hoog','New York',0.15),
(5002,'Nail Knite','Paris',0.13),
(5005,'Pit Alex','London',0.11),
(5006,'Mc Lyon','Paris',0.14);

insert into Orders values
(70001,150.50,'2025-10-04',3005,5002),
(70009,270.65,'2026-03-11',3001,5005),
(70002,65.26,'2026-05-05',3002,5001),
(70005,2400.60,'2026-02-27',3007,5001);

select * from Salesman;
select * from Orders;

-- 1. Create View

create view Sales_Report
as
select
Order_No,
Name,
Purchase_amount
from Orders
join Salesman
on Orders.Salesman_ID = Salesman.Salesman_ID;

select * from Sales_Report;


-- 2. Create Unique Nonclustered Index

create unique nonclustered index Salesman_index
on Salesman(Salesman_ID);

sp_helpindex Salesman;


-- 3. Stored Procedure: spGetOrdersByCity

create procedure spGetOrdersByCity
@city varchar(50)
as
begin
    select
    Name,
    Purchase_amount
    from Salesman
    join Orders
    on Salesman.Salesman_ID = Orders.Salesman_ID
    where City = @city;
end;

exec spGetOrdersByCity 'Paris';


-- 4. Stored Procedure with Output Parameter

create procedure spCountHighCommission
@commission decimal(4,2),
@total int output
as
begin
    select @total = count(Salesman_ID)
    from Salesman
    where Commission > @commission;
end;


declare @result int;

exec spCountHighCommission
0.12,
@result output;

select @result;


-- 5. Delete Records

delete from Orders
where Purchase_amount < 100;

select * from Orders;