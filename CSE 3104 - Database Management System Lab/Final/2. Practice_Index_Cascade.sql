CREATE DATABASE Practice_Index_Cascade; -- Create database
USE Practice_Index_Cascade; -- Select database


CREATE TABLE Worker -- Create Worker table
(
    WORKER_ID INT PRIMARY KEY, -- Primary Key
    FIRST_NAME VARCHAR(50), -- First name
    LAST_NAME VARCHAR(50), -- Last name
    SALARY INT, -- Salary
    JOINING_DATE DATETIME, -- Joining date
    DEPARTMENT VARCHAR(50) -- Department
);


INSERT INTO Worker -- Insert data into Worker table
VALUES
(1, 'Rana', 'Hamid', 100000, '2014-02-20 09:00:00', 'HR'),
(2, 'Sanjoy', 'Saha', 80000, '2014-06-11 09:00:00', 'Admin'),
(3, 'Mahmudul', 'Hasan', 300000, '2014-02-20 09:00:00', 'HR'),
(4, 'Asad', 'Zaman', 500000, '2014-02-20 09:00:00', 'Admin'),
(5, 'Sajib', 'Mia', 500000, '2014-06-11 09:00:00', 'Admin'),
(6, 'Alamgir', 'Kabir', 200000, '2014-06-11 09:00:00', 'Account'),
(7, 'Foridul', 'Islam', 75000, '2014-01-20 09:00:00', 'Account'),
(8, 'Keshob', 'Ray', 90000, '2014-04-11 09:00:00', 'Admin');


SELECT * FROM Worker; -- Show Worker table


-- Problem 1

CREATE INDEX idx_worker_salary -- Create non-unique index
ON Worker(SALARY); -- Index on SALARY column


-- Problem 2

CREATE INDEX idx_name_dept -- Create composite index
ON Worker(FIRST_NAME, DEPARTMENT); -- Composite index


-- Problem 3

CREATE UNIQUE INDEX idx_worker_id_unique -- Create unique index
ON Worker(WORKER_ID); -- Unique index on WORKER_ID


-- Problem 4

DROP INDEX Worker.idx_worker_salary; -- Delete index


-- Part 2 : Cascading


-- Problem 1

CREATE TABLE Departments -- Create parent table
(
    DeptID INT PRIMARY KEY, -- Primary Key
    DeptName VARCHAR(50) -- Department name
);


CREATE TABLE Staff -- Create child table
(
    StaffID INT PRIMARY KEY, -- Primary Key
    StaffName VARCHAR(50), -- Staff name
    DeptID INT, -- Foreign Key column

    FOREIGN KEY (DeptID)
    REFERENCES Departments(DeptID)
    ON DELETE CASCADE -- Delete child rows automatically
);


INSERT INTO Departments -- Insert into Departments
VALUES
(1, 'CSE'),
(2, 'EEE');


INSERT INTO Staff -- Insert into Staff
VALUES
(101, 'Rahim', 1),
(102, 'Karim', 1),
(103, 'Sadia', 2);


SELECT * FROM Departments; -- Show Departments table
SELECT * FROM Staff; -- Show Staff table


DELETE FROM Departments -- Delete parent row
WHERE DeptID = 1;

-- Related child rows from Staff will also be deleted


SELECT * FROM Staff; -- Check cascading delete


-- Problem 2

CREATE TABLE Clients -- Create Clients table
(
    CustomerID INT PRIMARY KEY, -- Primary Key
    CustomerName VARCHAR(50) -- Customer name
);


CREATE TABLE Orders -- Create Orders table
(
    OrderID INT PRIMARY KEY, -- Primary Key
    CustomerID INT -- Foreign Key column
);


ALTER TABLE Orders -- Alter Orders table
ADD CONSTRAINT fk_cust_update -- Constraint name
FOREIGN KEY (CustomerID)
REFERENCES Clients(CustomerID)
ON UPDATE CASCADE; -- Update child automatically


-- Problem 3

CREATE TABLE Projects -- Create parent table
(
    ProjectID INT,
    DeptCode VARCHAR(10),

    PRIMARY KEY(ProjectID, DeptCode) -- Composite Primary Key
);


CREATE TABLE Project_Tasks -- Create child table
(
    TaskID INT PRIMARY KEY, -- Primary Key
    ProjectID INT,
    DeptCode VARCHAR(10),

    FOREIGN KEY(ProjectID, DeptCode)
    REFERENCES Projects(ProjectID, DeptCode)
    ON DELETE CASCADE -- Composite foreign key cascade
);


-- Problem 4

CREATE TABLE Warehouse -- Create Warehouse table
(
    WarehouseID INT PRIMARY KEY, -- Primary Key
    WarehouseName VARCHAR(50) -- Warehouse name
);


CREATE TABLE Shipments -- Create Shipments table
(
    ShipmentID INT PRIMARY KEY, -- Primary Key
    ProductName VARCHAR(50), -- Product name
    WarehouseID INT, -- Foreign Key column

    FOREIGN KEY(WarehouseID)
    REFERENCES Warehouse(WarehouseID)
    ON UPDATE CASCADE -- Update automatically
    ON DELETE NO ACTION -- Restrict delete
);


INSERT INTO Warehouse -- Insert into Warehouse
VALUES
(1, 'Central'),
(2, 'North');


INSERT INTO Shipments -- Insert into Shipments
VALUES
(101, 'Laptop', 1),
(102, 'Mouse', 2);


SELECT * FROM Warehouse; -- Show Warehouse table
SELECT * FROM Shipments; -- Show Shipments table