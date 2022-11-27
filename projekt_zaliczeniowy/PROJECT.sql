CREATE DATABASE staging;
CREATE DATABASE prod;

USE [Staging]
GO


----- Rozpiêtoœæ czasowa wymiaru daty ma mieœciæ siê w przedziale 10 lat od daty pierwszego rekordu z tabeli sales
SELECT date 
FROM Sales 
ORDER BY date ASC

----------- DIM DATE -----------
USE [prod]
GO

CREATE TABLE dbo.DimDate (
 [DateKey] int NOT NULL,
 [Date] DATE NOT NULL,
 [Day] TINYINT NOT NULL,
 [WeekOfYear] TINYINT NOT NULL,
 [Month] TINYINT NOT NULL,
 [Quarter] TINYINT NOT NULL,
 [Year] INT NOT NULL
 )
DECLARE @CurrentDate DATE = '2004-12-31'
DECLARE @EndDate DATE = DATEADD(DAY, -1, DATEADD(YEAR, 10, @CurrentDate));
WHILE @CurrentDate < @EndDate
BEGIN
 INSERT INTO [dbo].[DimDate] (
 [DateKey],
 [Date],
 [Day],
 [WeekOfYear],
 [Month],
 [Quarter],
 [Year]
 )
 SELECT DateKey = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 +
DAY(@CurrentDate),
 DATE = @CurrentDate,
 Day = DAY(@CurrentDate),
 [WeekofYear] = DATEPART(wk, @CurrentDate),
 [Month] = MONTH(@CurrentDate),
 [Quarter] = DATEPART(q, @CurrentDate),
 [Year] = YEAR(@CurrentDate)
 SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

SELECT * FROM DimDate

------ DIM CUSTOMERS ----
CREATE TABLE [dbo].[DIM_Customers](
	[customers_idkey] int IDENTITY(1,1),
	[id] [int] NULL,
	[first_name] [varchar](50) NULL,
	[last_name] [varchar](50) NULL,
	[street] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[country] [varchar](50) NULL,
	[phone] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[EffStartDate] date,
	[EffEndDate] date
) ON [PRIMARY]
GO

---- DIM CARRIER ---------
CREATE TABLE [dbo].[DIM_Carrier](
	[carrier_idkey] int IDENTITY(1,1),
	[carrier_id] [int] NULL,
	[carrier_name] [varchar](50) NULL,
	[address] [varchar](50) NULL,
	[tax_id] [int] NULL,
	[contact_person] [varchar](50) NULL,
	[EffStartDate] date,
	[EffEndDate] date
) ON [PRIMARY]
GO



---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Proszê zaproponowaæ zestaw 3 zapytañ SQL u¿ywaj¹c dowolnych funkcji okienkowych takich
--jak rank () over lub funkcji analitycznych jak np. percent_rank lub stddev. W przypadkach 
--biznesowych takie zapytania dotycz¹ najczêœciej danych finansowych.--1. suma sprzeda¿y dla ka¿dego dnia z wyliczon¹ œredni¹ krocz¹c¹ dla danego dnia oraz trzech poprzednich. USE [prod]
GOWITH temp AS(
SELECT sum(amount) AS sales_amount ,cast(date as date) as date 
FROM dbo.Fact_Table
GROUP BY date
)
SELECT sales_amount, date,
AVG(sales_amount) OVER (ORDER BY date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS srednia_kroczaca
FROM temp
ORDER BY date


--2.w jakim percentylu znalaz³y siê firmy dostawcze pod k¹tem sumarycznej sprzeda¿y w 2007 roku + odchylenie standardowe 
--PERCENT_RANK() OVER
--STDEV()

WITH temp AS(
	SELECT carrier_idkey, SUM(amount) AS sales_amount
	FROM dbo.Fact_Table
	WHERE YEAR(date)=2007
	GROUP BY carrier_idkey
)
SELECT t.carrier_idkey, d.carrier_name, t.sales_amount,
	PERCENT_RANK() OVER (ORDER BY t.sales_amount) AS Percentiles,d.carrier_name,
	STDEV(t.sales_amount) OVER (ORDER BY t.sales_amount) AS std_dev
FROM temp t
JOIN dbo.DIM_Carrier d
ON d.carrier_id = t.carrier_idkey
ORDER BY t.carrier_idkey


-- 3. ranking stanów w ameryce w które w 2008 wygenerowa³y najwy¿sz¹ sprzeda¿
--rank() over
--group by cube

select top (10) 
	d.state as State,
	sum(amount) as sales_amount,
	rank() over (partition by year(date) order by sum(amount) desc) as Rank
from Fact_Table f
join DIM_Customers d on f.customers_idkey = d.customers_idkey
where d.country='United States' and year(date)=2008
group by cube(d.state, year(date))


--4. miesieczny ranking sprzedazowy dostawcow w 2009 
--PERCENT_RANK() over
--group by rollup

select 
	d.carrier_name,
	month(date) as month,
	sum(amount) as sales_amount,
	PERCENT_RANK() over (partition by month(date) order by sum(amount) desc) as Rank
from Fact_Table f
join DIM_Carrier d on f.carrier_idkey = d.carrier_idkey
where year(date)='2009'
group by rollup(carrier_name, month(date))

