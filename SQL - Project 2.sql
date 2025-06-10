-- ===============================================================
-- SQL Project 2:
-- ===============================================================
-- Project Objective:
-- You are building a small data warehouse using a star schema model.
-- The central FACT table is surrounded by several DIMENSION tables.
-- Your job is to:
--   1. Create the schema using Crows Foot Notation on diagram tool.
--   2. Write SQL to create all tables with proper keys and constraints.
--   3. Load data using provided INSERT scripts (see separate file).
--   4. Write analytical SQL queries using functions, joins, subqueries, and set operators.
-- ===============================================================

-- ===========================================
-- DIMENSION TABLES (You must create the schema using constraints)

-- DIM_Date
-- Columns:
--   DateID (PK), FullDate, Month, Quarter, Year

Create Table DIM_Date(
DateID INT NOT NULL,
FullDate DATE,
Month VARCHAR(20),
Quarter CHAR(2),
Year INT
);
Select * from DIM_Date

Alter table DIM_Date
Add Constraint PK_DIMDATE PRIMARY KEY (DateID);

-- DIM_Date
INSERT INTO DIM_Date VALUES (1, '2024-01-15', 'January', 'Q1', 2024);
INSERT INTO DIM_Date VALUES (2, '2024-03-20', 'March', 'Q1', 2024);
INSERT INTO DIM_Date VALUES (3, '2024-06-05', 'June', 'Q2', 2024);
INSERT INTO DIM_Date VALUES (4, '2024-09-10', 'September', 'Q3', 2024);
INSERT INTO DIM_Date VALUES (5, '2024-12-25', 'December', 'Q4', 2024);

-- DIM_Customer
-- Columns:
--   CustomerID (PK), FirstName, LastName, Email, Gender

Create Table DIM_Customer(
CustomerID INT NOT NULL,
FirstName VARCHAR(25),
LastName VARCHAR(25),
Email VARCHAR(50),
Gender CHAR(1) Check (Gender IN ('M', 'F'))
);

Alter Table DIM_Customer
Add Constraint PK_CustomerID PRIMARY KEY (CustomerID)

-- DIM_Customer
INSERT INTO DIM_Customer VALUES (101, 'Alice', 'Smith', 'alice@example.com', 'F');
INSERT INTO DIM_Customer VALUES (102, 'Bob', 'Jones', 'bob@example.com', 'M');
INSERT INTO DIM_Customer VALUES (103, 'Carol', 'White', 'carol@example.com', 'F');
INSERT INTO DIM_Customer VALUES (104, 'Dan', 'Brown', 'dan@example.com', 'M');
INSERT INTO DIM_Customer VALUES (105, 'Eva', 'Green', 'eva@example.com', 'F');


-- DIM_Product
-- Columns:
--   ProductID (PK), ProductName, Category, Price

 Create Table DIM_Product(
 ProductID INT NOT NULL,
 ProductName VARCHAR(25),
 Category VARCHAR(25),
 Price INT
 );

 Alter Table DIM_Product
 Add Constraint PK_ProductID PRIMARY KEY(ProductID);


 -- DIM_Product
INSERT INTO DIM_Product VALUES (201, 'Laptop', 'Electronics', 1200);
INSERT INTO DIM_Product VALUES (202, 'Desk Chair', 'Furniture', 150);
INSERT INTO DIM_Product VALUES (203, 'Mouse', 'Electronics', 25);
INSERT INTO DIM_Product VALUES (204, 'Monitor', 'Electronics', 300);
INSERT INTO DIM_Product VALUES (205, 'Standing Desk', 'Furniture', 700);


-- DIM_Store
-- Columns:
--   StoreID (PK), StoreName, Region

Create Table DIM_Store(
StoreID INT NOT NULL,
StoreName VARCHAR(50),
Region VARCHAR(10) DEFAULT 'East'
);

Alter Table DIM_Store
Add Constraint PK_StoreID PRIMARY KEY(StoreID);


-- DIM_Store
INSERT INTO DIM_Store VALUES (301, 'Main St Store', 'East');
INSERT INTO DIM_Store VALUES (302, 'Central Store', 'West');
INSERT INTO DIM_Store VALUES (303, 'South Branch', 'South');
INSERT INTO DIM_Store VALUES (304, 'North Hub', 'North');


-- DIM_Salesperson
-- Columns:
--   SalespersonID (PK), FirstName, LastName, HireDate

Create table DIM_Salesperson(
SalespersonID INT NOT NULL,
FirstName VARCHAR(25),
LastName VARCHAR(25),
HireDate DATE DEFAULT getdate()
);

Alter Table DIM_Salesperson
Add Constraint PK_SalespersonID PRIMARY KEY(SalespersonID);


-- DIM_Salesperson
INSERT INTO DIM_Salesperson VALUES (401, 'David', 'Lee', '2018-06-01');
INSERT INTO DIM_Salesperson VALUES (402, 'Emma', 'Taylor', '2022-04-15');
INSERT INTO DIM_Salesperson VALUES (403, 'Frank', 'Stone', '2019-09-30');
INSERT INTO DIM_Salesperson VALUES (404, 'Grace', 'Wells', '2020-02-18');


-- ===========================================
-- FACT TABLE: FACT_Sales
-- Columns:
--   SalesID (PK), DateID (FK), CustomerID (FK), ProductID (FK),
--   StoreID (FK), SalespersonID (FK), Quantity, TotalAmount

Create Table FACT_Sales(
SalesID INT NOT NULL,
DateID INT, 
CustomerID INT,
ProductID INT,
StoreID INT,
SalespersonID INT,
Quantity INT Check (Quantity > 0),
TotalAmount INT,
);

Alter Table FACT_Sales
Add Constraint PK_SalesID PRIMARY KEY(SalesID),
    Constraint FK_DateID FOREIGN KEY(DateID) REFERENCES DIM_Date(DateID),
	Constraint FK_CustomerID FOREIGN KEY(CustomerID) REFERENCES DIM_Customer(CustomerID),
	Constraint FK_ProductID FOREIGN KEY(ProductID) REFERENCES DIM_Product(ProductID),
	Constraint FK_StoreID FOREIGN KEY(StoreID) REFERENCES DIM_Store(StoreID),
	Constraint FK_SalespersonID FOREIGN KEY(SalespersonID) REFERENCES DIM_Salesperson(SalespersonID);


INSERT INTO FACT_Sales VALUES (1, 1, 101, 201, 301, 401, 1, 1200);
INSERT INTO FACT_Sales VALUES (2, 2, 102, 202, 302, 402, 2, 300);
INSERT INTO FACT_Sales VALUES (3, 3, 101, 203, 301, 401, 4, 100);
INSERT INTO FACT_Sales VALUES (4, 1, 103, 202, 302, 402, 1, 150);
INSERT INTO FACT_Sales VALUES (5, 4, 104, 204, 303, 403, 2, 600);
INSERT INTO FACT_Sales VALUES (6, 5, 105, 205, 304, 404, 1, 700);
INSERT INTO FACT_Sales VALUES (7, 3, 102, 203, 301, 401, 3, 75);
INSERT INTO FACT_Sales VALUES (8, 4, 101, 204, 303, 403, 2, 600);
INSERT INTO FACT_Sales VALUES (9, 2, 104, 205, 304, 404, 1, 700);


-- Constraints to use:
-- - Use PRIMARY KEY and FOREIGN KEY constraints
-- - Use CHECK for constraints like Quantity > 0
-- - Use DEFAULT for columns like HireDate or Region if applicable

-- ===========================================
-- PHASE 2: Query Writing Tasks (Write queries for each prompt below)
-- Select * From Fact_Sales
-- 1. Show the total sales per product category.
 Select * From DIM_Product

Select P.ProductID, P.ProductName, Sum(FS.TotalAmount) As TotalSales
From DIM_Product P
Inner Join FACT_Sales FS
On P.ProductID = FS.ProductID
Group By P.ProductID, P.ProductName

-- 2. List all customers who have made purchases in more than one region.

Select C.CustomerID, Concat(C.FirstName,' ', C.LastName) As FullName
From DIM_Customer C
Inner Join FACT_Sales FS
ON C.CustomerID = FS.CustomerID
Inner Join DIM_Store S
On FS.StoreID = S.StoreID
Group By C.CustomerID, Concat(C.FirstName,' ', C.LastName)
Having Count(FS.StoreID) > 1



-- 3. Find the top 3 salespersons by total revenue.
Select * From DIM_Salesperson
Select * From FACT_Sales

Select Top 3 SalespersonID, TotalRevenue
From
(Select SalespersonID, Sum(TotalAmount) As TotalRevenue 
From FACT_Sales
Group By SalespersonID) As SalesPerson_TotalRevenue
Order By TotalRevenue Desc;

-- 4. Show the most recent sale for each customer.
Select * from Dim_Customer;
Select * From FACT_Sales;
Select * From DIM_Store;
Select * From DIM_Product;

Select CustomerID, StoreID, FullName, ProductName
From
(Select FS.SalesID,C.CustomerID, Concat(C.FirstName,' ', C.LastName) As FullName, P.ProductName, Dense_Rank() Over (Partition By C.CustomerID Order by FS.SalesID Desc) As ranked_by_recentsales, S.StoreID
From DIM_Customer C 
Inner Join FACT_Sales FS
On C.CustomerID = FS.CustomerID
Inner Join DIM_Store S
On FS.StoreID = S.StoreID
Inner Join DIM_Product P On
FS.ProductID = P.ProductID) AS recent_Sales
Where ranked_by_recentsales = 1

-- 5. Find all sales made in the first quarter of any year.

Select * From DIM_Date;
Select * From FACT_Sales;

Select FS.SalesID
From FACT_Sales FS 
Inner Join DIM_Date D
On FS.DateID = D.DateID
Where D.Quarter = 'Q1'


-- 6. List customers who never bought anything from the "Electronics" category.
Select * From DIM_Product;
Select * From FACT_Sales;

Select C.CustomerID, Concat(C.FirstName,' ', C.LastName) AS FullName, P.Category
From DIM_Customer C
Inner JOIN FACT_Sales FS
On C.CustomerID = FS.CustomerID
Inner Join DIM_Product P
On FS.ProductID = P.ProductID
Where P.Category NOT IN ('Electronics');

-- 7. Find the average quantity sold per product.
Select * From DIM_Product;
Select * From FACT_Sales;

Select P.ProductName, Avg(FS.Quantity) As AverageQuantity
From DIM_Product P
Inner Join FACT_Sales FS
On P.ProductID = FS.ProductID
Group By P.ProductID, P.ProductName


-- 8. List products that were never sold.
Select * From DIM_Product;
Select * From FACT_Sales;

Select Distinct(P.ProductName)
From DIM_Product P
Left Join FACT_Sales FS
On P.ProductID = FS.ProductID
Where FS.ProductID IS NULL;

-- 9. Show customers who have the same first name as any salesperson.
Select * From DIM_Salesperson;
Select * From DIM_Customer;

(Select FirstName 
From DIM_Customer

Intersect

Select FirstName
From  DIM_Salesperson);


-- 10. List dates where total sales amount exceeded $1000.

Select * From FACT_Sales;
Select * From DIM_Date;

Select D.FullDate, Sum(FS.TotalAmount) AS TotalSalesAmount
From DIM_Date D
Inner Join FACT_Sales FS
On D.DateID = FS.DateID
Group By FS.DateID, D.FullDate
Having Sum(FS.TotalAmount) > 1000;

-- 11. Find all customers who only bought one product (distinct product).
Select * From FACT_Sales;
Select * From DIM_Customer;

Select C.CustomerID, CONCAT(C.FirstName, ' ', C.LastName) AS FullName
From DIM_Customer C
Inner JOIN FACT_Sales FS 
ON C.CustomerID = FS.CustomerID
Group BY C.CustomerID, CONCAT(C.FirstName, ' ', C.LastName)
Having COUNT(DISTINCT FS.ProductID) = 1;

  
-- 12. Return sales transactions where total amount is more than average for that product.
Select * From FACT_Sales;
Select * From DIM_Product;

Select FS.SalesID, P.ProductName, FS.TotalAmount,
       AVG(FS2.TotalAmount) AS AvgForProduct
From FACT_Sales FS
Inner Join DIM_Product P 
ON FS.ProductID = P.ProductID
Inner Join FACT_Sales FS2 
ON FS2.ProductID = FS.ProductID
GROUP BY FS.SalesID, P.ProductName, FS.TotalAmount, FS.ProductID
HAVING FS.TotalAmount > AVG(FS2.TotalAmount)

-- 13. Show sales made by salespersons hired before 2020.
Select * From FACT_Sales;
Select * From DIM_Salesperson;

Select FS.SalesID, FS.TotalAmount, FS.Quantity,
       SP.SalespersonID, SP.FirstName, SP.LastName, SP.HireDate
From FACT_Sales FS
Inner Join DIM_Salesperson SP 
ON FS.SalespersonID = SP.SalespersonID
Where SP.HireDate < '2020-01-01';



-- 14. List products sold in every region.
Select * From FACT_Sales;
Select * From DIM_Salesperson;
Select * From DIM_Store;

Select P.ProductID, P.ProductName
From DIM_Product P
JOIN FACT_Sales FS 
ON P.ProductID = FS.ProductID
JOIN DIM_Store S 
ON FS.StoreID = S.StoreID
Group BY P.ProductID, P.ProductName
Having COUNT(DISTINCT S.Region) = (
    Select COUNT(DISTINCT Region) 
	From DIM_Store
);



-- 15. Show products sold either in Region 'East' or by Salesperson hired in 2022, but not both. (Use EXCEPT/UNION)
Select * From FACT_Sales;
Select * From DIM_Product;
Select * From DIM_Store;

    (Select DISTINCT P.ProductID, P.ProductName
    From FACT_Sales FS
    Inner Join DIM_Product P ON FS.ProductID = P.ProductID
    Inner Join DIM_Store S ON FS.StoreID = S.StoreID
    WHERE S.Region = 'East'

    UNION

    Select DISTINCT P.ProductID, P.ProductName
    From FACT_Sales FS
    Inner Join DIM_Product P ON FS.ProductID = P.ProductID
    Inner Join DIM_Salesperson SP ON FS.SalespersonID = SP.SalespersonID
    Where YEAR(SP.HireDate) = 2022)


EXCEPT


    (Select DISTINCT P.ProductID, P.ProductName
    From FACT_Sales FS
    Inner Join DIM_Product P ON FS.ProductID = P.ProductID
    Inner Join DIM_Store S ON FS.StoreID = S.StoreID
    Inner Join DIM_Salesperson SP ON FS.SalespersonID = SP.SalespersonID
    Where S.Region = 'East' AND YEAR(SP.HireDate) = 2022);


-- ===============================================================
-- END OF PROJECT REQUIREMENTS
