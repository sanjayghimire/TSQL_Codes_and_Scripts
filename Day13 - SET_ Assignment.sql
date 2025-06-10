-- Q1: Find all employees who are also customers OR who have placed at least one sales order.
-- Use a UNION of two filtered sets.

-- Tables used:
-- Select * From HumanResources.Employee
-- Select * From Sales.Customer
-- Select * From Sales.SalesOrderHeader

(Select E.BusinessEntityID
From HumanResources.Employee E
Inner Join Sales.Customer C 
ON E.BusinessEntityID = C.CustomerID)

Union

(Select c.CustomerID
From Sales.Customer C
Inner Join Sales.SalesOrderHeader SOH
ON c.CustomerID = SOH.CustomerID)

-- ================================================

-- Q2: List product names that are either (a) manufactured in-house or (b) have a safety stock level below 100.
-- Use UNION. Must retrieve each from a different filtering strategy.

-- Tables used:
-- Select * From Production.Product

(Select Name 
From Production.Product 
Where MakeFlag = 1)

Union 

(Select Name 
From Production.Product 
Where SafetyStockLevel < 100)

-- ================================================

-- Q3: Get customers who are in the Customer table but have never had any SalesOrderDetail lines tied to them.
-- Use EXCEPT and joins.

-- Tables used:
-- Select * From Sales.Customer
-- Select * From Sales.SalesOrderHeader
-- Select * From Sales.SalesOrderDetail

(Select CustomerID 
From Sales.Customer)

Except

(Select SOH.CustomerID
From Sales.SalesOrderHeader SOH
Inner Join Sales.SalesOrderDetail SOD
ON SOH.SalesOrderID = SOD.SalesOrderID)

-- ================================================


-- Q4: Find customers who have placed orders and also appear as individual contacts in the Person table.
-- Use INTERSECT to find shared BusinessEntityIDs.

-- Tables used:
-- Select * From Sales.Customer
-- Select * From Sales.SalesOrderHeader
-- Select * From Person.Person

(Select BusinessEntityID
From Person.Person

Intersect 

(Select CustomerID
From Sales.SalesOrderHeader

Intersect

Select CustomerID
From Sales.Customer))

-- Q5: Find product names that are either categorized as 'Bikes' or have been ordered more than 50 times.
-- Use UNION with a JOIN + GROUP BY in one branch.

-- Tables used:
-- Select * From Production.Product
-- Select * From Production.ProductSubcategory
-- Select * From Sales.SalesOrderDetail

(Select P.Name
From Production.Product P
Inner JOIN Production.ProductSubcategory PS 
ON P.ProductSubcategoryID = PS.ProductSubcategoryID
Where PS.Name LIKE '%Bike%')

Union

(Select P.Name
From Production.Product P
Inner Join Sales.SalesOrderDetail SOD
On SOD.ProductID = P.ProductID
Group By P.Name
Having Count(SOD.SalesOrderID) > 50)