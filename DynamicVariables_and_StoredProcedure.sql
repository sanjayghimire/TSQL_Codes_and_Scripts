-- ==========================================
-- Project Assignment: Sales Margin Report (AdventureWorksDW2017)
-- Time Allocation: 2 Hours
-- ==========================================

-- 🎯 Business Scenario:
-- You are working as a Data Engineer for a company that analyzes product performance.
-- The sales team needs a report that shows the profitability of each product subcategory by region.

-- 📌 Business Requirement:
-- The report should include the following for each product subcategory:
--   1. Product Subcategory Name
--   2. Region Name (from geography dimension)
--   3. Total Sales Amount
--   4. Total Product Cost
--   5. Profit Margin Percentage
--   6. Sales Rank based on Total Sales Amount in that region

-- 🧮 Profit Margin Formula:
--     (Total Sales Amount - Total Product Cost) / Total Sales Amount * 100

-- ✅ Deliverables:
-- 1. Create a scalar-valued function:
--      Name: fn_ProfitMargin
--      Inputs: @SalesAmount (MONEY), @TotalCost (MONEY)
--      Output: Profit margin as a DECIMAL(10,2)
--      Note: Return NULL if SalesAmount is 0 or NULL.

Create Function fn_ProfitMargin(@SalesAmount MONEY, @TotalCost MONEY)
Returns Decimal(10,2)
AS
Begin 
	Declare @ProfitMargin Decimal(10,2);
	If @SalesAmount IS Null OR @SalesAmount = 0
	Set @ProfitMargin = Null;
	Else
		Set @ProfitMargin = ((@SalesAmount - @TotalCost) / @SalesAmount) * 100;
	Return  @ProfitMargin;
End 


Select PS.EnglishProductSubcategoryName, G.EnglishCountryRegionName, Sum(FS.SalesAmount) AS TotalSalesAmount, Sum(FS.TotalProductCost) As TotalProductCost, 
dbo.fn_ProfitMargin(Sum(FS.SalesAmount), sum(FS.TotalProductCost)) AS ProfitMArgin, Dense_Rank() OVER (PARTITION BY G.EnglishCountryRegionName ORDER BY SUM(fs.SalesAmount) DESC) AS salesRank
	From FactResellerSales FS
	Inner Join DimGeography G
	On FS.SalesTerritoryKey = G.SalesTerritoryKey
	Inner Join DimProduct P 
	On FS.ProductKey = P.ProductKey
	Inner Join DimProductSubcategory PS
	On PS.ProductSubcategoryKey = P.ProductSubcategoryKey
	Group by PS.EnglishProductSubcategoryName, G.EnglishCountryRegionName;


-- 2. Create a stored procedure:
--      Name: usp_SalesMarginReport
--      Inputs: @Year (INT), @Region (NVARCHAR)
--      Output: A SELECT query showing all required columns
--      Logic:
--          - Use FactResellerSales, DimProduct, DimProductSubcategory, DimGeography, DimDate
--          - Apply the scalar function to compute ProfitMargin%
--          - Use ROW_NUMBER or RANK to get SalesRank by region
--          - Filter by CalendarYear and RegionCountryName


Create or Alter Proc  usp_SalesMarginReport(@Year INT, @Region NVARCHAR(50 ))
As
Begin
	Select PS.EnglishProductSubcategoryName, G.EnglishCountryRegionName, Sum(FS.SalesAmount) AS TotalSalesAmount, Sum(FS.TotalProductCost) As TotalProductCost, 
dbo.fn_ProfitMargin(Sum(FS.SalesAmount), Sum(FS.TotalProductCost)) AS ProfitMArgin, Dense_Rank() OVER (PARTITION BY G.EnglishCountryRegionName ORDER BY SUM(fs.SalesAmount) DESC) AS salesRank
	From FactResellerSales FS
	Inner Join DimDate D
	On FS.OrderDateKey = D.DateKey
	Inner Join DimGeography G
	On FS.SalesTerritoryKey = G.SalesTerritoryKey
	Inner Join DimProduct P 
	On FS.ProductKey = P.ProductKey
	Inner Join DimProductSubcategory PS
	On PS.ProductSubcategoryKey = P.ProductSubcategoryKey
	Where D.CalendarYear = @Year AND G.EnglishCountryRegionName = @Region
    Group By PS.EnglishProductSubcategoryName, G.EnglishCountryRegionName;
End



-- 3. Execute the procedure with test parameters:
--      EXEC usp_SalesMarginReport @Year = 2013, @Region = 'United States';

-- 📂 Tables to Use:
--   - Select * From FactResellerSales
--   - Select * From DimProduct
--   - Select * From DimProductSubcategory
--   - Select * From DimGeography
--   - Select * From DimDate

-- 🧠 Tips:
--   - Use INNER JOINs to connect the fact and dimension tables
--   - Aggregate using SUM()
--   - Use WHERE clause to filter by input parameters
--   - Function should be called inside SELECT statement

-- 📌 Reminder:
-- Do not include hardcoded values — use the input parameters!
-- Structure your code so it's readable, logical, and reusable.
-- ==========================================
