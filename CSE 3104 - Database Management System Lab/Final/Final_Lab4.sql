create database RDBMS;
use RDBMS;

--Customer_Table
create table customer(
customer_ID int not null,
Names varchar(30),
Age int,
city varchar(25),
primary key(customer_ID)
);

insert into Customer values (9, 'Sobhan', 22, 'Rajshahi');
select * from Customer;

--Non_Clustered
create nonclustered index customer_index
on customer(Names)
select * from  Customer where Names = 'Sobhan'


--Orders_Table
create table Orders(
Order_ID int not null,
Customer_Id int,
Product_ID int,
Times datetime,
primary key(Order_ID),
foreign key(customer_ID) references Customer(customer_ID)
);

--clustered index
create clustered index Order_index
on Orders(Order_ID)

--Products_Table
create table Products(
Product_ID int,
Order_ID int,
Quantity int,
price int,
foreign key(order_ID) references Orders(order_ID)
);

create unique nonclustered index Product_index
on products(quantity)