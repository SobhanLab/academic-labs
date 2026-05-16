CREATE DATABASE Practice_View; -- Create database
USE Practice_View; -- Select database


CREATE TABLE salesman -- Create salesman table
(
    salesman_id INT PRIMARY KEY, -- Primary Key
    name VARCHAR(50), -- Salesman name
    city VARCHAR(50), -- City
    commission DECIMAL(4,2) -- Commission
);


INSERT INTO salesman -- Insert data into salesman table
VALUES
(5001, 'James', 'New York', 0.15),
(5002, 'Nail', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5007, 'Paul Adam', 'Rome', 0.13),
(5003, 'Lauson Hen', 'San Jose', 0.12);


CREATE TABLE customer -- Create customer table
(
    customer_id INT PRIMARY KEY, -- Primary Key
    cust_name VARCHAR(50), -- Customer name
    city VARCHAR(50), -- City
    grade INT, -- Grade
    salesman_id INT -- Salesman ID
);


INSERT INTO customer -- Insert data into customer table
VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006),
(3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007);


CREATE TABLE orders -- Create orders table
(
    ord_no INT PRIMARY KEY, -- Primary Key
    purch_amt DECIMAL(10,2), -- Purchase amount
    ord_date DATE, -- Order date
    customer_id INT, -- Customer ID
    salesman_id INT -- Salesman ID
);


INSERT INTO orders -- Insert data into orders table
VALUES
(70001, 150.50, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.50, '2012-08-17', 3009, 5003),
(70007, 948.50, '2012-09-10', 3005, 5002),
(70005, 2400.60, '2012-07-27', 3007, 5001),
(70008, 5760.00, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.40, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.60, '2012-04-25', 3002, 5001);


SELECT * FROM salesman; -- Show salesman table
SELECT * FROM customer; -- Show customer table
SELECT * FROM orders; -- Show orders table


-- Problem 1
CREATE VIEW NewYork_Salesman -- Create view
AS
SELECT *
FROM salesman
WHERE city = 'New York'; -- Salesmen from New York

SELECT * FROM NewYork_Salesman; -- Show view


-- Problem 2
CREATE VIEW Salesman_Info -- Create view
AS
SELECT salesman_id, name, city
FROM salesman; -- Show selected columns

SELECT * FROM Salesman_Info; -- Show view


-- Problem 3
CREATE VIEW High_Commission -- Create view
AS
SELECT *
FROM salesman
WHERE city = 'New York'
AND commission > 0.13; -- Commission greater than 13%

SELECT * FROM High_Commission; -- Show view

-- Problem 4
CREATE VIEW Grade_Count -- Create view
AS
SELECT grade, COUNT(customer_id) AS Total_Customer
FROM customer
GROUP BY grade; -- Count customers by grade

SELECT * FROM Grade_Count; -- Show view


-- Problem 5
CREATE VIEW Daily_Order_Summary -- Create view
AS
SELECT
    ord_date,
    COUNT(customer_id) AS Total_Customer,
    COUNT(DISTINCT salesman_id) AS Total_Salesman,
    AVG(purch_amt) AS Average_Order,
    SUM(purch_amt) AS Total_Order
FROM orders
GROUP BY ord_date;

SELECT * FROM Daily_Order_Summary; -- Show view


-- Problem 6
CREATE VIEW Order_Details -- Create view
AS
SELECT
    orders.ord_no,
    salesman.name AS Salesman_Name,
    customer.cust_name AS Customer_Name,
    orders.purch_amt
FROM orders
INNER JOIN salesman
ON orders.salesman_id = salesman.salesman_id
INNER JOIN customer
ON orders.customer_id = customer.customer_id;

SELECT * FROM Order_Details; -- Show view


-- Problem 7
CREATE VIEW Highest_Order_Salesman -- Create view
AS
SELECT salesman.name, orders.purch_amt
FROM orders
INNER JOIN salesman
ON orders.salesman_id = salesman.salesman_id
WHERE purch_amt =
(
    SELECT MAX(purch_amt)
    FROM orders
);

SELECT * FROM Highest_Order_Salesman; -- Show view


-- Problem 8
CREATE VIEW Highest_Order_ThreeTimes -- Create view
AS
SELECT salesman_id, COUNT(*) AS Total
FROM orders
GROUP BY salesman_id
HAVING COUNT(*) >= 3; -- Salesman issued highest orders at least 3 times

SELECT * FROM Highest_Order_ThreeTimes; -- Show view


-- Problem 9
CREATE VIEW Highest_Grade_Customer -- Create view
AS
SELECT *
FROM customer
WHERE grade =
(
    SELECT MAX(grade)
    FROM customer
);

SELECT * FROM Highest_Grade_Customer; -- Show view


-- Problem 10
CREATE VIEW Salesman_City_Count -- Create view
AS
SELECT city, COUNT(salesman_id) AS Total_Salesman
FROM salesman
GROUP BY city;

SELECT * FROM Salesman_City_Count; -- Show view


-- Problem 11
CREATE VIEW Salesman_Order_Summary -- Create view
AS
SELECT
    salesman.name,
    AVG(orders.purch_amt) AS Average_Order,
    SUM(orders.purch_amt) AS Total_Order
FROM salesman
INNER JOIN orders
ON salesman.salesman_id = orders.salesman_id
GROUP BY salesman.name;

SELECT * FROM Salesman_Order_Summary; -- Show view


-- Problem 12
CREATE VIEW Multiple_Customers -- Create view
AS
SELECT salesman_id, COUNT(customer_id) AS Total_Customer
FROM customer
GROUP BY salesman_id
HAVING COUNT(customer_id) > 1;

SELECT * FROM Multiple_Customers; -- Show view


-- Problem 13
CREATE VIEW Customer_Salesman_Match -- Create view
AS
SELECT
    customer.cust_name,
    salesman.name,
    customer.city,
    salesman.city
FROM customer
INNER JOIN salesman
ON customer.salesman_id = salesman.salesman_id;

SELECT * FROM Customer_Salesman_Match; -- Show view


-- Problem 14
CREATE VIEW Daily_Order_Count -- Create view
AS
SELECT ord_date, COUNT(ord_no) AS Total_Order
FROM orders
GROUP BY ord_date;

SELECT * FROM Daily_Order_Count; -- Show view


-- Problem 15
CREATE VIEW October_Salesman -- Create view
AS
SELECT DISTINCT salesman.name
FROM orders
INNER JOIN salesman
ON orders.salesman_id = salesman.salesman_id
WHERE ord_date = '2012-10-10';

SELECT * FROM October_Salesman; -- Show view


-- Problem 16
CREATE VIEW August_October_Salesman -- Create view
AS
SELECT DISTINCT salesman.name
FROM orders
INNER JOIN salesman
ON orders.salesman_id = salesman.salesman_id
WHERE ord_date = '2012-08-17'
OR ord_date = '2012-10-10';

SELECT * FROM August_October_Salesman; -- Show view