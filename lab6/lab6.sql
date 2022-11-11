USE AdventureWorksDW2019
GO  

-- ZADANIE 1
WITH temp AS(
SELECT sum(SalesAmount) AS amount ,OrderDate 
FROM dbo.FactInternetSales
GROUP BY OrderDate
)

SELECT amount, OrderDate,
AVG(amount) OVER (ORDER BY OrderDate ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS srednia_kroczaca
FROM temp
ORDER BY OrderDate


-- ZADANIE 2
SELECT OrderDateMonth AS month_of_year,ISNULL([0], 0) AS [0], ISNULL([1], 0) AS [1],ISNULL([2], 0) AS [2],
	ISNULL([3], 0) AS [3],ISNULL([4], 0) AS [4],ISNULL([5], 0) AS [5],ISNULL([6], 0) AS [6],ISNULL([7], 0) AS [7],
	ISNULL([8], 0) AS [8],ISNULL([9], 0) AS [9],ISNULL([10], 0) AS [10]
FROM  
(
  SELECT 
  SalesTerritoryKey,
  MONTH(OrderDate) as OrderDateMonth,
  sum(SalesAmount) as SalesAmount
  FROM  dbo.FactInternetSales
  WHERE YEAR(OrderDate) = 2011
  GROUP BY MONTH(OrderDate),SalesTerritoryKey
) AS SourceTable  
PIVOT  
(  
  SUM(SalesAmount)  
  FOR SalesTerritoryKey IN ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]) 
) AS PivotTable;


-- ZADANIE 3
SELECT OrganizationKey, DepartmentGroupKey, SUM(Amount) AS Sum_Amount
FROM FactFinance
GROUP BY ROLLUP(OrganizationKey, DepartmentGroupKey)
ORDER BY OrganizationKey

-- ZADANIE 4
SELECT OrganizationKey, DepartmentGroupKey, SUM(Amount) AS Sum_Amount
FROM FactFinance
GROUP BY CUBE(OrganizationKey, DepartmentGroupKey)
ORDER BY OrganizationKey


-- ZADANIE 5
WITH temp AS(
	SELECT OrganizationKey, SUM(Amount) AS SumAmount
	FROM dbo.FactFinance
	WHERE YEAR(Date)=2012
	GROUP BY OrganizationKey
)

SELECT t.OrganizationKey, t.SumAmount, PERCENT_RANK() OVER (ORDER BY t.SumAmount) AS Percentiles,d.OrganizationName
FROM temp t
JOIN dbo.DimOrganization d
ON d.OrganizationKey = t.OrganizationKey
ORDER BY t.OrganizationKey


-- ZADANIE 6
WITH temp AS(
	SELECT OrganizationKey, SUM(Amount) AS SumAmount
	FROM dbo.FactFinance
	WHERE YEAR(Date)=2012
	GROUP BY OrganizationKey
)

SELECT t.OrganizationKey, t.SumAmount, PERCENT_RANK() OVER (ORDER BY t.SumAmount) AS Percentiles,
	STDEV(t.SumAmount) OVER (ORDER BY t.SumAmount) AS std_dev, d.OrganizationName
FROM temp t
JOIN dbo.DimOrganization d
ON d.OrganizationKey = t.OrganizationKey
ORDER BY t.OrganizationKey



