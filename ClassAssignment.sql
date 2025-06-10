
/*
===========================================================
STAR SCHEMA ASSIGNMENT
===========================================================

INSTRUCTIONS:
- Create the required dimension and fact tables
- Apply all necessary constraints
- Insert provided data
- Answer the aggregation queries (Q1 - Q5) at the bottom
*/

-- ====================================
-- PART 1: CREATE DIMENSION TABLES
-- ====================================

-- Create 5 Dimension Tables:
-- 1. DimDate (DateKey, FullDate, Month, Quarter, Year)
--    - CHECK Month BETWEEN 1 AND 12
--    - DEFAULT Quarter = 1, CHECK Quarter BETWEEN 1 AND 4


Create Table DimDate(
DateKey INT NOT NULL PRIMARY KEY,
FullDate Date,
Month INT CHECK (Month BETWEEN 1 AND 12),
Quarter INT Default 1 CHECK (Quarter BETWEEN 1 AND 4),
Year INT
);


-- 2. DimEmployee (EmployeeID, FirstName, LastName, Gender, JobTitle)
--    - CHECK Gender IN ('M', 'F')
--    - DEFAULT JobTitle = 'Unknown'

Create Table DimEmployee(
EmployeeID INT NOT NULL PRIMARY KEY,
FirstName VARCHAR(25),
LastName VARCHAR(25),
Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
JobTitle VARCHAR(25) DEFAULT 'UnKnown'
);



-- 3. DimProduct (ProductID, ProductName, Category, Price)
--    - CHECK Price > 0 AND <= 10000
--    - DEFAULT Category = 'General'

Create Table DimProduct(
ProductID INT NOT NULL PRIMARY KEY,
ProductName VARCHAR(25),
Category VARCHAR(25) DEFAULT 'General',
Price DECIMAL(7,2) CHECK (Price >0 AND Price <= 10000)
);



-- 4. DimStore (StoreID, StoreName, Region)
--    - CHECK Region IN ('East', 'West', 'North', 'South')
--    - DEFAULT Region = 'East'

Create Table DimStore(
StoreID INT NOT NULL PRIMARY KEY,
StoreName VARCHAR(25),
Region VARCHAR(10) Default 'East' CHECK (Region IN ('East', 'West', 'North', 'South'))
);


-- 5. DimCustomer (CustomerID, FullName, Age, Gender, Email)
--    - CHECK Age BETWEEN 0 AND 120
--    - DEFAULT Gender = 'U'

Create Table DimCustomer(
CustomerID INT NOT NULL PRIMARY KEY,
FullName VARCHAR(50),
Age INT CHECK (AGE BETWEEN 0 AND 120),
Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
Email VARCHAR(50)
);


-- Add all appropriate NOT NULL constraints
-- Make sure each table has a PRIMARY KEY

-- ====================================
-- PART 2: CREATE FACT TABLE
-- ====================================

-- Create FactSales table with:
-- - SalesID (Primary Key)
-- - Foreign Keys to all 5 dimension tables
-- - SaleAmount (Decimal), Quantity (Int), TransactionType (Varchar)

Create Table FactSales(
SalesID INT NOT NULL PRIMARY KEY Default -1,
SaleAmount DECIMAl,
Quantity INT,
TransactionType VARCHAR(25),
DateKey INT,
EmployeeID INT,
ProductID INT,
StoreID INT,
CustomerID INT
FOREIGN KEY(DateKey) REFERENCES DimDate(DateKey) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
FOREIGN KEY(EmployeeID) REFERENCES DimEmployee(EmployeeID) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
FOREIGN KEY(ProductID) REFERENCES DimProduct(ProductID) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
FOREIGN KEY(StoreID) REFERENCES DimStore(StoreID) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
FOREIGN KEY(CustomerID) REFERENCES DimCustomer(CustomerID) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
);


-- Foreign keys must include:
--   ON DELETE SET DEFAULT
--   ON UPDATE SET DEFAULT

-- This requires default records in each dimension table (use -1)

-- ====================================
-- PART 3: INSERT SCRIPTS
-- ====================================

-- Use the insert scripts provided in 'star_schema_assignment.sql'
-- Each DIM table must include:
--   - A default record with ID = -1
--   - At least 2 valid records
-- Include variations to test CHECK constraints

Select * From DimDate;

INSERT INTO DimDate (DateKey, FullDate, Month, Quarter, Year)
VALUES (-1, '1900-01-01', 1, 1, 1900);

INSERT INTO DimDate (DateKey, FullDate, Month, Quarter, Year)
VALUES (101, '2023-01-01', 1, 1, 2023);
INSERT INTO DimDate (DateKey, FullDate, Month, Quarter, Year)
VALUES (102, '2023-06-15', 6, 2, 2023);
INSERT INTO DimDate (DateKey, FullDate, Month, Quarter, Year)
VALUES (103, '2023-09-10', 9, 3, 2023);

-- INSERT INTO DimDate VALUES (104, '2023-13-01', 13, 1, 2023); -- Test Check Constraint


Select * From DimEmployee;

INSERT INTO DimEmployee (EmployeeID, FirstName, LastName, Gender, JobTitle)
VALUES (-1, 'Default', 'Employee', 'M', 'Unknown');

INSERT INTO DimEmployee VALUES (201, 'Alice', 'Andrews', 'F', 'Analyst');
INSERT INTO DimEmployee VALUES (202, 'Bob', 'Baker', 'M', 'Accountant');
INSERT INTO DimEmployee VALUES (203, 'Cathy', 'Cole', 'F', DEFAULT);

-- INSERT INTO DimEmployee VALUES (204, 'Test', 'Person', 'X', 'Tester'); -- Test Check Constraint


Select * From DimPRoduct;

INSERT INTO DimProduct (ProductID, ProductName, Category, Price)
VALUES (-1, 'DefaultProduct', DEFAULT, 0.01);

INSERT INTO DimProduct VALUES (301, 'Laptop', 'Electronics', 899.99);
INSERT INTO DimProduct VALUES (302, 'Desk Lamp', 'Furniture', 49.99);
INSERT INTO DimProduct VALUES (303, 'Whiteboard', DEFAULT, 59.99);

-- INSERT INTO DimProduct VALUES (304, 'BrokenItem', 'Junk', -10); -- Test Check Constraint


Select * From DimStore;

INSERT INTO DimStore (StoreID, StoreName, Region)
VALUES (-1, 'DefaultStore', DEFAULT);

INSERT INTO DimStore VALUES (401, 'EastMart', 'East');
INSERT INTO DimStore VALUES (402, 'NorthMart', 'North');
INSERT INTO DimStore VALUES (403, 'WestMart', 'West');


-- INSERT INTO DimStore VALUES (404, 'CentralStore', 'Central'); -- Test Check Constraint


Select * From DimCustomer;

INSERT INTO DimCustomer (CustomerID, FullName, Age, Gender, Email)
VALUES (-1, 'Default Customer', 0, DEFAULT, 'unknown@example.com');

INSERT INTO DimCustomer VALUES (501, 'John Doe', 28, 'M', 'john@example.com');
INSERT INTO DimCustomer VALUES (502, 'Jane Smith', 34, 'F', 'jane@example.com');
INSERT INTO DimCustomer VALUES (503, 'Emily Clarke', 22, 'F', 'emily@example.com');
INSERT INTO DimCustomer VALUES (504, 'Michael Brown', 45, 'M', 'michael@example.com');
INSERT INTO DimCustomer VALUES (505, 'Lisa Taylor', 31, 'F', 'lisa@example.com');
INSERT INTO DimCustomer VALUES (506, 'Daniel Wilson', 36, 'M', 'daniel@example.com');
INSERT INTO DimCustomer VALUES (507, 'Samantha Lee', 18, 'F', 'samantha@example.com');
INSERT INTO DimCustomer VALUES (508, 'George Martin', 29, 'M', 'george@example.com');
INSERT INTO DimCustomer VALUES (509, 'Olivia Johnson', 38, 'F', 'olivia@example.com');
INSERT INTO DimCustomer VALUES (510, 'David Clark', 65, 'M', 'david@example.com');
INSERT INTO DimCustomer VALUES (511, 'Grace Miller', 26, 'F', 'grace@example.com');
INSERT INTO DimCustomer VALUES (512, 'Henry Adams', 33, 'M', 'henry@example.com');

-- INSERT INTO DimCustomer VALUES (513, 'Old Joe', 130, 'M', 'joe@old.com'); -- Test Check Constrain



Select * From FactSales;

INSERT INTO FactSales (SalesID, DateKey, EmployeeID, ProductID, StoreID, CustomerID, SaleAmount, Quantity, TransactionType)
VALUES (1, 101, 201, 301, 401, 501, 500.00, 1, 'Online');

INSERT INTO FactSales (SalesID, DateKey, EmployeeID, ProductID, StoreID, CustomerID, SaleAmount, Quantity, TransactionType)
VALUES (2, 102, 202, 302, 402, 502, 60.00, 2, 'In-Store');





-- ====================================
-- PART 4: QUERY SECTION
-- ====================================

-- Q1: Count the number of employees with JobTitle starting with 'A'
-- Write your query below:
 
 Select Count(EmployeeId) As NumberOfEmployees
 From DimEmployee
 Where JobTitle LIKE 'A%';

-- Q2: Count the number of products priced above $50
-- Write your query below:

 Select Count(ProductId) As NumberOfProducts
 From DimProduct
 Where Price > 50;

-- Q3: Count the number of customers aged between 18 and 35
-- Write your query below:

 Select Count(CustomerId) As NumberOfCustomers
 From DimCustomer
 Where Age > 18 AND Age < 35;

-- Q4: List all distinct years from the DimDate table
-- Write your query below:

Select  Distinct Year From DimDate;

-- Q5: Count the number of stores grouped by Region
-- Write your query below:

Select Region, Count(StoreID) AS NumberOfStores
From DimStore 
Group By Region;