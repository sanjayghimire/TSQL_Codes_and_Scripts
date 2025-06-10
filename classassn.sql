

--Total Sales for Every Sales Person
Select SPName, SUM(SalesAmount) AS Total_Sales
	FROM Orders 
	Group By SPName


--Total Sales by Product
SELECT ProductName, SUM(SalesAmount) AS Total_Sales
	FROM Orders
	GROUP BY ProductName

--Total Sales By Store for iphone7
Select ProductName, SUM(SalesAmount) AS Total_Sales
	FROM Orders
	--WHERE ProductName <> 'Iphone-7'
	GROUP BY ProductName
	HAVING ProductName <> 'Iphone-7'

SELECT count(*) AS Total_Number_Of_Transaction --NULLS are not ignored
	FROM Orders

SELECT count(Storelocation) Total_Number_Of_Transaction--NULLS for Storelocation are ignored
	FROM Orders

-- Select * from Orders
SELECT TOP 1 SalesAmount
	FROM Orders 
	Order by 1 desc


-- More practice: 
--Total Sales By Location for iphone-7 where SalesAmount>1000
Select StoreLocation, SUM(SalesAmount) AS TotalSales
From Orders
Where ProductName = 'iphone-7' AND SalesAmount > 1000
Group By StoreLocation;


--Find the total amount, average sales amount, max and min of ALL sales in the Sales Order Header table
Select * from [Sales].[SalesOrderHeader]

Select SUM(TotalDue) AS TotalSales, AVG(TotalDue) AS AverageSales,
    MAX(TotalDue) AS MaxSale, MIN(TotalDue) AS MinSale
From Sales.SalesOrderHeader;

-- List the ID’s of customers and number of orders they placed also order by count of their orders from highest to lowest
-- 20 or more orders
Select CustomerID, COUNT(SalesOrderID) AS OrderCount
From Sales.SalesOrderHeader
Group by CustomerID
Having COUNT(SalesOrderID) >= 20
Order by OrderCount DESC


-- only consider cid between 11000 and 12000
Select CustomerID, COUNT(SalesOrderID) AS OrderCount
From Sales.SalesOrderHeader
Where CustomerID Between 11000 and 12000
Group by CustomerID
Order by OrderCount DESC


-- Do this after
-- and having count of orders more than 20

Select CustomerID, COUNT(SalesOrderID) AS OrderCount
From Sales.SalesOrderHeader
Where CustomerID Between 11000 and 12000
Group by CustomerID
Having Count(SalesOrderID)>20
Order by OrderCount DESC

-- List the ID’s of customers by order of the total amount they’ve spent and total is more than 500,000

Select CustomerID, Sum(TotalDue) AS TotalSpent
From Sales.SalesOrderHeader
Group by CustomerID
Having Sum(TotalDue)>500000
Order by TotalSpent DESC;

USE AdventureWorks2017;
GO
--Find the total sales for each customer 
Select CustomerID, SUM(TotalDue) AS TotalSales
From Sales.SalesOrderHeader

--Table: Sales.SalesOrderHeader


/* Find total Sales of each customer who has made Sales worth more than 100,000 dollars */
Select CustomerID, Sum(TotalDue) AS TotalSales
From Sales.SalesOrderHeader
Group by CustomerID
Having Sum(TotalDue)>100000
Order by TotalSales DESC;

-- List each Sales ID with Order date, Due date, and ship date display them in different formats
Select SalesOrderID, OrderDate, FORMAT(OrderDate, 'MMMM dd, yyyy') AS FormattedOrderDate,
    DueDate, FORMAT(DueDate, 'MM/dd/yyyy') AS FormattedDueDate,
    ShipDate,FORMAT(ShipDate, 'yyyy-MM-dd') AS FormattedShipDate
From Sales.SalesOrderHeader;
/*
Get me ID of most common shipping method for all orders of 2011 only*/

Select TOP 1 ShipMethodID, COUNT(*) AS TimesUsed
From Sales.SalesOrderHeader
Where YEAR(OrderDate) = 2011
Group By ShipMethodID
Order By TimesUsed DESC;
USE LDP_Practice;
GO