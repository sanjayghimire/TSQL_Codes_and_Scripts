/*
1.	Create a VIEW to display SalesPerson, SalesAmount, 
MaxSalesBySalesPerson (out of all sales by a sales person max sales amount), 
MinSalesBySalesPerson (out of all sales by a sales person min sales amount), 
TotalSalesBySalesPerson (sum of all sales by a sales person), 
OrganizationAvgSales (average of all transactions for all sales person), 
OrganizationTotalSales (sum of all transactions for all sales person). 
Details should not be lost there are 13 rows in the table and output should 
have 13 rows. 
*/


Create view SalesSummary as
Select 
    s.salesPerson,
    s.salesAmount,
    (Select max(salesAmount) From sales where salesPerson = s.salesPerson) as maxSalesBySalesPerson,
    (Select min(salesAmount) From sales where salesPerson = s.salesPerson) as minSalesBySalesPerson,
    (Select sum(salesAmount) From sales where salesPerson = s.salesPerson) as totalSalesBySalesPerson,
    (Select avg(salesAmount) From sales) as organizationAvgSales,
    (Select sum(salesAmount) From sales) as organizationTotalSales
From sales s;




*****************************************************************
/*
2. Create another VIEW referencing above VIEW without details 
(one row for each employee)
 no need of individual sales transaction details required.
 */

Create view salesSummaryBySalesPerson as
Select SalesPerson,
    Max(maxSalesBySalesPerson) as maxSalesBySalesPerson,
    Min(minSalesBySalesPerson) as minSalesBySalesPerson,
    Sum(totalSalesBySalesPerson) as totalSalesBySalesPerson,
    Max(organizationAvgSales) as organizationAvgSales,
    Max(organizationTotalSales) as organizationTotalSales
From SalesSummary
Group By SalesPerson;



*****************************************************************
-- Use Select * From Sales.SalesOrderHeader table
-- Calculate totalsales for each salesperson in each year

--expected output:
/*SPID	YEAR	TOTALSALES TotalOrgSalesinthatyear
1		2018	1000		3000
1		2017	1500		5000
2		2018	2000		3000
3		2017	3500		5000
*/


Select 
    soh.SalesPersonID As SpId,
    Year(soh.OrderDate) As Year,
    Sum(soh.TotalDue) As TotalSales,
    org.TotalOrgSalesInThatYear
From Sales.SalesOrderHeader soh
Join (
    Select Year(OrderDate) As Year, Sum(TotalDue) As TotalOrgSalesInThatYear
    From Sales.SalesOrderHeader
    Group By Year(OrderDate)
) org On Year(soh.OrderDate) = org.Year
Group By soh.SalesPersonID, Year(soh.OrderDate), org.TotalOrgSalesInThatYear
Order By SpId, Year;

*****************************************************************
-- PRINT 1 to 100 without using Loops

With Numbers As (
    Select 1 As Num
    Union All
    Select Num + 1
    From Numbers
    Where Num < 100
)
Select Num
From Numbers;


*****************************************************************
-- Print factorial of 1 to 10

With Fact (Num, Factorial) As (
    Select 1, 1
    Union All
    Select Num + 1, Factorial * (Num + 1)
    From Fact
    Where Num < 10
)
Select Factorial
From Fact;



******************************************************************
-- PRINT A to Z using recursive CTE

With Alphabets AS (
    Select CAST('A' AS CHAR(1)) AS Letter
    Union ALL
    Select CHAR(ASCII(Letter) + 1)
    From Alphabets
    Where Letter < 'Z'
)
Select Letter
From Alphabets;

*****************************************************************
-- Print first 10 fibonacci numbers

WITH Fibonacci (FibNum, NextNum, Count) AS (
    SELECT 0, 1, 1    
    UNION ALL
    SELECT NextNum, FibNum + NextNum, Count + 1
    FROM Fibonacci
    WHERE Count < 10
)
SELECT FibNum
FROM Fibonacci;
*******************************************************************
-- Create an Employee table.  
CREATE TABLE dbo.MyEmployees  
(  
EmployeeID smallint NOT NULL,  
FirstName nvarchar(30)  NOT NULL,  
LastName  nvarchar(40) NOT NULL,  
Title nvarchar(50) NOT NULL,  
DeptID smallint NOT NULL,  
ManagerID int NULL,  
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)   
);  
-- Populate the table with values.  
INSERT INTO dbo.MyEmployees VALUES   
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)  
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)  
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)  
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)  
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)  
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)  
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)  
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)  
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);  
 
Select * From dbo.MyEmployees

/*Using a recursive common table expression to display multiple levels of recursion 
to show hierarchy of managers and employees who report to them */

WITH EmployeeHierarchy AS (
    Select EmployeeID, CAST(FirstName + ' ' + LastName AS NVARCHAR(100)) AS ManagerEmployeeHierarchy
    From dbo.MyEmployees
    Where ManagerID IS NULL

    Union All

    Select e.EmployeeID, CAST(h.ManagerEmployeeHierarchy + ' > ' + e.FirstName + ' ' + e.LastName AS NVARCHAR(100))
    From dbo.MyEmployees e
    INNER JOIN EmployeeHierarchy h ON e.ManagerID = h.EmployeeID
)

Select ManagerEmployeeHierarchy
From EmployeeHierarchy;


-- 1.Write a query that will return the names of all salespeople who have more than one order:

WITH OrderCounts AS (
    Select Salespeopleid, COUNT(*) AS OrderCount
    From Orders
    Group By Salespeopleid
)
Select s.Name
From OrderCounts oc
JOIN Salespeople s ON oc.Salespeopleid = s.ID
WHERE oc.OrderCount > 1;


-- 2.Write a query that returns the salesperson with the 2 nd highest total amount ordered:

WITH SalesTotals AS (
    Select Salespeopleid, SUM(Amt) AS TotalSales
    From Orders
    Group By Salespeopleid
),
RankedSales AS (
    Select Salespeopleid, TotalSales,
           RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    From SalesTotals
)
Select s.Name, rs.TotalSales
From RankedSales rs
JOIN Salespeople s ON rs.Salespeopleid = s.ID
WHERE rs.SalesRank = 2;


-- 3.Write a query that returns total and average sales by month for 1998:

WITH SalesIn1998 AS (
    Select *
    From Orders
    WHERE YEAR(orderdate) = 1998
),
MonthlySales AS (
    Select 
        MONTH(orderdate) AS Month,
        SUM(Amt) AS TotalSales,
        AVG(Amt) AS AverageSales
    From SalesIn1998
    Group By MONTH(orderdate)
)
Select Month, TotalSales, AverageSales
From MonthlySales
Order By Month;

-- 4.Write a query that returns all salespeople that failed to get any orders for each year
--starting in 1997:

Select s.Name, y.SalesYear
From Salespeople s
Cross Join (
    Select Distinct Year(OrderDate) As SalesYear
    From Orders
    Where Year(OrderDate) >= 1997
) y
Where Not Exists (
    Select 1
    From Orders o
    Where o.SalespeopleId = s.Id
      And Year(o.OrderDate) = y.SalesYear
)
Order By y.SalesYear, s.Name;
