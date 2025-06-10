
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

-- 2. DimEmployee (EmployeeID, FirstName, LastName, Gender, JobTitle)
--    - CHECK Gender IN ('M', 'F')
--    - DEFAULT JobTitle = 'Unknown'

-- 3. DimProduct (ProductID, ProductName, Category, Price)
--    - CHECK Price > 0 AND <= 10000
--    - DEFAULT Category = 'General'

-- 4. DimStore (StoreID, StoreName, Region)
--    - CHECK Region IN ('East', 'West', 'North', 'South')
--    - DEFAULT Region = 'East'

-- 5. DimCustomer (CustomerID, FullName, Age, Gender, Email)
--    - CHECK Age BETWEEN 0 AND 120
--    - DEFAULT Gender = 'U'

-- Add all appropriate NOT NULL constraints
-- Make sure each table has a PRIMARY KEY

-- ====================================
-- PART 2: CREATE FACT TABLE
-- ====================================

-- Create FactSales table with:
-- - SalesID (Primary Key)
-- - Foreign Keys to all 5 dimension tables
-- - SaleAmount (Decimal), Quantity (Int), TransactionType (Varchar)

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

-- ====================================
-- PART 4: QUERY SECTION
-- ====================================

-- Q1: Count the number of employees with JobTitle starting with 'A'
-- Write your query below:


-- Q2: Count the number of products priced above $50
-- Write your query below:


-- Q3: Count the number of customers aged between 18 and 35
-- Write your query below:


-- Q4: List all distinct years from the DimDate table
-- Write your query below:


-- Q5: Count the number of stores grouped by Region
-- Write your query below:

