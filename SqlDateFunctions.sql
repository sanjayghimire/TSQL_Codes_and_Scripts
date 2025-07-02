/*
=========================================================
 SQL Assignment: Advanced Use of Built-in Functions
 Database: AdventureWorks2017
=========================================================

Objective:
Test your understanding of SQL built-in functions including 
Date Functions, String Functions, Logical Functions, and 
Mathematical Functions through real-world-style problems.

Instructions:
Write your SQL queries below each question using AdventureWorks2017.
*/

-- Q1: Extract Month Names
-- From Sales.SalesOrderHeader, return the full month name from OrderDate.
Select * from Sales.SalesOrderHeader;


Select DateName(Month,OrderDate) AS MonthName
From Sales.SalesOrderHeader;

-- Q2: Days Until End of Month
-- Calculate number of days between today (GETDATE()) and end of the current month.
Select DateDiff(Day, getdate(), eomonth(getdate()));


-- Q3: Case-Sensitive Filtering
-- From Person.Person, return rows where FirstName contains 'a' but not 'A'.
Select FirstName
From Person.Person
Where FirstName Not Like 'A%' AND FirstName Like '%a%';

-- Q4: Email Domain Extractor
-- From Person.EmailAddress, extract everything after '@' in EmailAddress.
Select Substring(EmailAddress, CharIndex('@', EmailAddress) + 1, len(EmailAddress))
From Person.EmailAddress;

-- Q5: Dynamic Age Calculation
-- Select * From HumanResources.Employee, calculate current age using BirthDate.
Select DateDiff(Year, BirthDate, getDate())
From HumanResources.Employee;

-- Q6: Conditional Salary Increase
-- InSelect * From HumanResources.EmployeePayHistory, increase rate by:
-- 10% if DepartmentID = 10
-- 5% if DepartmentID = 20


-- Q7: Pad and Concatenate IDs
-- From Sales.Customer, generate AW0000CustomerID format (6-digit zero-padded).
Select Concat('AW0000',CustomerId) As NewCustomerId
From Sales.Customer;

-- Q8: Round Off to Nearest 100
-- From Sales.SalesOrderHeader, round TotalDue to the nearest 100.

Select Round(TotalDue, 2)
From Sales.SalesOrderHeader;

-- Q9: Leap Year Checker
-- From YEAR(OrderDate) in Sales.SalesOrderHeader, return only leap years.

Select YEAR(OrderDate) AS LeapYear
From Sales.SalesOrderHeader
Where ((YEAR(OrderDate) % 4 = 0 AND YEAR(OrderDate) % 100 != 0) OR (YEAR(OrderDate) % 400 = 0)
);

-- Q10: Weekday Name Formatter
-- From Person.Person using ModifiedDate, return text like: "Modified on Monday."
SELECT Concat('Modified On ', DateName(WeekDay, ModifiedDate)) As ModifiedDayName
From Person.Person;

-- Last Challenge:
-- Combine 3 or more functions to show:
-- "Customer AW000150 gets a 20% discount for spending over $1000."
Select Concat('Customer ', Concat('AW000',CustomerId), ' gets a 20% discount for spending over ', Format(Cast(1000 As Money), '$'))
From Sales.Customer
Where CustomerId = 150;
