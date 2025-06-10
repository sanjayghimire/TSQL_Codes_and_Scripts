
-----------------------------------------------------------
--1. Write a Dynamic SQL Query for BusinessEntityID,
--FirstName, LastName, HireDate, DOB
--whose FirstName starts with A

Select * From [Person].[Person]
Select * From [HumanResources].[Employee]
------------------------------------------------------------
Go
Declare @sql NVARCHAR(MAX)

Set @sql = 
'Select P.BusinessEntityID, P.FirstName, P.LastName, E.HireDate, E.BirthDate
From Person.Person P
Inner Join HumanResources.Employee E
ON P.BusinessEntityID = E.BusinessEntityID
Where P.FirstName Like ''A%'''

Print @sql

Exec (@sql)
Go
-----------------------------------------------------------
--2. Write a Dynamic SQL Code for all the employewe details (BusinessEntityID, 
--FirstName, LastName, HireDate / DOB in 107 style format 
--whose FirstName starts with A
-- User has the choice to select either HireDate or Birthdate 


Declare @DateType NVARCHAR(20) = 'HireDate';
Declare @BEID NVARCHAR(50) = 'P.BusinessEntityID';
Declare @FN NVARCHAR(50) = 'P.FirstName';
Declare @LN NVARCHAR(50) = 'P.LastName';


Declare @sql NVARCHAR(MAX);

SET @sql = 
'Select 
    ' + @BEID + ',
    ' + @FN + ',
    ' + @LN + ',
    CONVERT(VARCHAR(30), E.' + @DateType + ', 107) AS FormattedDate
From Person.Person P
Join HumanResources.Employee E 
    ON P.BusinessEntityID = E.BusinessEntityID
Where ' + @FN + ' LIKE ''A%'''

Exec (@sql);
Go


-------------------------------------------------------------

-----------------------------------------------------------
--3. Write a Dynamic SQL Code for all the employee details 
-- make column names and table names dynamic too

Select * From [HumanResources].[Employee]

Declare @BE NVARCHAR(25) = '[BusinessEntityID]';
Declare @NI NVARCHAR(25) = '[NationalIDNumber]';
Declare @LI NVARCHAR(25) = '[LoginID]';
Declare @ON NVARCHAR(50) = '[OrganizationNode]';
Declare @OL NVARCHAR(10) = '[OrganizationLevel]';
Declare @JT NVARCHAR(50) = '[JobTitle]';
Declare @BD NVARCHAR(50) = '[BirthDate]';
Declare @MS NVARCHAR(5) = '[MaritalStatus]';
Declare @GE NVARCHAR(5) = '[Gender]';
Declare @HI NVARCHAR(50) = '[HireDate]';
Declare @SF NVARCHAR(5) = '[SalariedFlag]';
Declare @VH NVARCHAR(50) = '[VacationHours]';
Declare @SL NVARCHAR(50) = '[SickLeaveHours]';
Declare @CF NVARCHAR(5) = '[CurrentFlag]';
Declare @RG NVARCHAR(100) = '[rowguid]';
Declare @MD NVARCHAR(50) = '[ModifiedDate]';

Declare @sql NVARCHAR(MAX);

Set @sql = 'Select ' + 
    @BE + ',' + 
    @NI + ',' + 
    @LI + ',' + 
    @ON + ',' + 
    @OL + ',' + 
    @JT + ',' + 
    @BD + ',' + 
    @MS + ',' + 
    @GE + ',' + 
    @HI + ',' + 
    @SF + ',' + 
    @VH + ',' + 
    @SL + ',' + 
    @CF + ',' + 
    @RG + ',' + 
    @MD + 
' From HumanResources.Employee;';

Exec (@sql);
Go


-------------------------------------------------------------


/* Write a D-SQL code to display the total 
   Sales of Product by Product Category, Product Sub-Category and Product in which you are
   getting the filter values of Product Category Name and Product Sub-Category Name from front-end application*/


Declare @CategoryName NVARCHAR(100) = 'Bikes';
Declare @SubCategoryName NVARCHAR(100) = 'Mountain Bikes';

Declare @sql NVARCHAR(MAX);

Set @sql = '
Select 
    PC.Name As ProductCategory,
    PSC.Name As ProductSubCategory,
    P.Name As Product,
    Sum(SOD.LineTotal) As TotalSales
From Sales.SalesOrderDetail SOD
Join Production.Product P On SOD.ProductID = P.ProductID
Join Production.ProductSubcategory PSC On P.ProductSubcategoryID = PSC.ProductSubcategoryID
Join Production.ProductCategory PC On PSC.ProductCategoryID = PC.ProductCategoryID
Where PC.Name = ''' + @CategoryName + '''
  And PSC.Name = ''' + @SubCategoryName + '''
Group By PC.Name, PSC.Name, P.Name;
';

Print(@sql)
Exec (@sql);

Go


   /* Write a D-SQL code to display the address of all the employees for a specific department.
      Department name will be given by user.
   */
Select * From [HumanResources].[Employee]
Select * From [HumanResources].[EmployeeDepartmentHistory]
Select * From [HumanResources].[Department]
Select * From [Person].[BusinessEntityAddress]
Select * From [Person].[Address]

Declare @DeptName NVARCHAR(100) = 'Engineering'; 
Declare @sql NVARCHAR(MAX);

Set @sql = '
Select Distinct 
    E.BusinessEntityID,
    P.FirstName,
    P.LastName,
    A.AddressLine1,
    A.AddressLine2,
    A.City,
    A.StateProvinceID,
    A.PostalCode
From HumanResources.Department D
Join HumanResources.EmployeeDepartmentHistory EDH On D.DepartmentID = EDH.DepartmentID
Join HumanResources.Employee E On EDH.BusinessEntityID = E.BusinessEntityID
Join Person.Person P On E.BusinessEntityID = P.BusinessEntityID
Join Person.BusinessEntityAddress BEA On E.BusinessEntityID = BEA.BusinessEntityID
Join Person.Address A On BEA.AddressID = A.AddressID
Where D.Name = ''' + @DeptName + ''';';

Print (@sql)
Exec (@sql);

Go

   /* Write a D-SQL to print the no of employees from each country.
      Country name will be given by user.
   */
   Select * From HumanResources.Employee
   Select * From Person.Address
   Select * From [Person].[CountryRegion]
   Select * From Person.BusinessEntityAddress
   Select * From [Person].[StateProvince]

Declare @CountryName NVARCHAR(100) = 'United States'; 

Declare @sql NVARCHAR(MAX);

Set @sql = '
Select 
    CR.Name AS CountryName,
    COUNT(DISTINCT E.BusinessEntityID) AS EmployeeCount
From HumanResources.Employee E
Join Person.BusinessEntityAddress BEA On E.BusinessEntityID = BEA.BusinessEntityID
Join Person.Address A On BEA.AddressID = A.AddressID
Join Person.StateProvince SP On A.StateProvinceID = SP.StateProvinceID
Join Person.CountryRegion CR On SP.CountryRegionCode = CR.CountryRegionCode
Where CR.Name = ''' + @CountryName + '''
Group By CR.Name;';


Print (@sql)
Exec (@sql);

