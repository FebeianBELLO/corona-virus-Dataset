create Database mentorness_project_1;
USE mentorness_project_1;
 SELECT  * FROM[Corona Virus Dataset]
 --check column type--
 sp_help [Corona Virus Dataset];
  -- checking  for null in the columns--
  SELECT *
  FROM [Corona Virus Dataset] WHERE
  Province IS NULL
   OR Country_Region IS NULL
   OR  Latitude IS NULL
   OR Longitude IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR  Deaths IS NULL
   OR  Recovered IS NULL;

--Checking the total number of rows--
 SELECT COUNT(*) AS Total_Number_Of_Rows
FROM [Corona Virus Dataset];

 --start and end date, for this to be done we need to convert the Date column --

--  we need to convert Date column from nvarchar to int --
select Date from[Corona Virus Dataset]
select * from  [Corona Virus Dataset]  where Date like'%-%-%'
select * from  [Corona Virus Dataset]  where Date like'%/%/%'
 --changing date with '-' to '/' --
 update  [Corona Virus Dataset] 
 set Date= REPLACE(Date,'-','/')
 where Date like '%-%-%';
 --Add column Date_converted, column type DATE--
 alter table [Corona Virus Dataset]
 add Date_converted DATE;
 --converting nvarchar(Date) to convert_Date(DATE)-- 
  update [Corona Virus Dataset]
  set Date_converted= convert(DATE,Date,103);
--checking dataset-- 
  select Date_converted from [Corona Virus Dataset]
  select * from [Corona Virus Dataset]
  sp_help  [Corona Virus Dataset];
  --drop column--
 alter table [Corona Virus Dataset]
 drop column  Date;
  
 --start and end date--
  SELECT 
   MIN(Date_converted) as Startdate,
   MAX(Date_converted) as Enddate
FROM [Corona Virus Dataset]


 -- numbers  of months present in the dataset--
SELECT 
    DATEPART(YEAR, [Date_converted]) AS Year,
    COUNT(DISTINCT DATEPART(MONTH, [Date_converted])) AS Numbers_Of_Months
FROM 
    [Corona Virus Dataset]
GROUP BY 
    DATEPART(YEAR, [Date_converted])
ORDER BY 
    DATEPART(YEAR, [Date_converted]);
	
	-- to find the monthly average we need to convert--
 --converting the confirmed column(nvarchar) to Confirmed_no(int)--
 --create column --
 Alter table [Corona Virus Dataset]
 Add  Confirmed_no int;
 update [Corona Virus Dataset]
 set Confirmed_no=cast(Confirmed as int)
-- checking--
select * from [Corona Virus Dataset]
 sp_help [Corona Virus Dataset]
 --dropping th confirmed columnn--
 alter table [Corona Virus Dataset]
 drop column confirmed;
 --repeating the same process for Deaths--
  --create column --
 Alter table [Corona Virus Dataset]
 Add  Deaths_no int;
 update [Corona Virus Dataset]
 set Deaths_no=cast(Deaths as int)
-- checking--
select * from [Corona Virus Dataset]
 sp_help [Corona Virus Dataset]
 --dropping th confirmed columnn--
 alter table [Corona Virus Dataset]
 drop column Deaths;
 --repeating the same process for Recovered--
  --create column --
 Alter table [Corona Virus Dataset]
 Add  Recovered_no int;
 update [Corona Virus Dataset]
 set Recovered_no=cast(Recovered as int)
-- checking--
select * from [Corona Virus Dataset]
 sp_help [Corona Virus Dataset]
 --dropping th confirmed columnn--
 alter table [Corona Virus Dataset]
 drop column Recovered;

--monthly avg for confirmed,death,recoverd  --
SELECT 
    YEAR(Date_converted) AS year,
    MONTH (Date_converted) AS month,
    AVG(Confirmed_no) AS avg_confirmed,
    AVG(Deaths_no) AS avg_deaths,
    AVG(Recovered_no) AS avg_recovered
FROM
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date_converted), 
    MONTH(Date_converted)
ORDER BY 
    year, 
    month;

-- most  frequency value for confimed_no, Deaths_no, Recovered_no  each Month --
--confirmed--
 WITH MonthlyData AS ( SELECT
        DATEPART(YEAR, Date_converted) AS Year,
        DATEPART(MONTH, Date_converted) AS Month, Confirmed_no 
FROM [Corona Virus Dataset]),ConfirmedCounts AS ( SELECT Year, Month, Confirmed_no,
        COUNT(*) AS Frequency FROM MonthlyData
    GROUP BY Year, Month, Confirmed_no),
MostFrequentConfirmed AS (
    SELECT Year,  Month, Confirmed_no, Frequency,
        ROW_NUMBER() OVER (PARTITION BY Year, Month ORDER BY Frequency DESC) AS RowNum
    FROM ConfirmedCounts)
SELECT Year, Month, Confirmed_no AS MostFrequentConfirmed, Frequency
FROM MostFrequentConfirmed
WHERE RowNum = 1 ORDER BY
    Year, Month;
--death--
WITH MonthlyData AS ( SELECT
        DATEPART(YEAR, Date_converted) AS Year,
        DATEPART(MONTH, Date_converted) AS Month,
        Deaths_no FROM [Corona Virus Dataset]),
DeathsCounts AS ( SELECT Year, Month, Deaths_no,
        COUNT(*) AS Frequency FROM  MonthlyData
    GROUP BY Year, Month, Deaths_no),
MostFrequentDeaths AS (SELECT Year, Month, Deaths_no, Frequency,
        ROW_NUMBER() OVER (PARTITION BY Year, Month ORDER BY Frequency DESC) AS RowNum
    FROM DeathsCounts)
SELECT Year,Month, Deaths_no AS MostFrequentDeaths, Frequency
FROM MostFrequentDeaths WHERE RowNum = 1
ORDER BY Year, Month;

--Recovered_no--
 WITH MonthlyData AS ( SELECT
        DATEPART(YEAR, Date_converted) AS Year,
        DATEPART(MONTH, Date_converted) AS Month, Recovered_no
    FROM [Corona Virus Dataset]),
RecoveredCounts AS (SELECT Year, Month, Recovered_no,
        COUNT(*) AS Frequency FROM MonthlyData
    GROUP BY Year, Month, Recovered_no),
MostFrequentRecovered AS ( SELECT Year,Month,Recovered_no,Frequency,
        ROW_NUMBER() OVER (PARTITION BY Year, Month ORDER BY Frequency DESC) AS RowNum
    FROM RecoveredCounts)
SELECT Year, Month, Recovered_no AS MostFrequentRecovered,
    Frequency FROM MostFrequentRecovered
WHERE  RowNum = 1
ORDER BY Year, Month;
  --minimum value for Deaths, Confirmed, and Recovered-- 
  SELECT
    DATEPART(YEAR, Date_converted) AS Year,
    MIN(Confirmed_no) AS Min_Confirmed,
    MIN(Deaths_no) AS Min_Deaths,
    MIN(Recovered_no) AS Min_Recovered
FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR, Date_converted)
ORDER BY Year;
	--maximum  and min value for Deaths, Confirmed, and Recovered--
	SELECT
    DATEPART(YEAR, Date_converted) AS Year,
    MAX(Confirmed_no) AS Max_Confirmed,
    MAX(Deaths_no) AS Max_Deaths,
    MAX(Recovered_no) AS Max_Recovered,
	MIN(Confirmed_no) AS Min_Confirmed,
    MIN(Deaths_no) AS Min_Deaths,
    MIN(Recovered_no) AS Min_Recovered
FROM [Corona Virus Dataset]
GROUP BY DATEPART(YEAR, Date_converted)
ORDER BY Year;
	--The total number of case of confirmed, deaths, recovered each month--
SELECT
    DATEPART(YEAR, Date_converted) AS Year,
    DATEPART(MONTH, Date_converted) AS Month,
    SUM(Confirmed_no) AS Total_Confirmed,
    SUM(Deaths_no) AS Total_Deaths,
    SUM(Recovered_no) AS Total_Recovered
FROM [Corona Virus Dataset]
GROUP BY
    DATEPART(YEAR, Date_converted),
    DATEPART(MONTH, Date_converted)
ORDER BY
    Year, Month;
--total,average,Variance,standarddeviation of Confirmed each month--
SELECT 
    YEAR(Date_converted) AS Year,
    MONTH(Date_converted) AS Month,
    SUM(Confirmed_no) AS Total,
    AVG(Confirmed_no) AS Average,
    STDEV(Confirmed_no) AS StandardDeviation,
    (STDEV(Confirmed_no) * STDEV(Recovered_no)) AS Variance
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date_converted), MONTH(Date_converted)
ORDER BY Year, Month;

--total,average,Variance,standarddeviation of Death--
SELECT 
    YEAR(Date_converted) AS Year,
    MONTH(Date_converted) AS Month,
    SUM(Deaths_no) AS Total,
    AVG(Deaths_no) AS Average,
    STDEV(Deaths_no) AS StandardDeviation,
    (STDEV(Deaths_no) * STDEV(Deaths_no)) AS Variance
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date_converted), MONTH(Date_converted)
ORDER BY Year, Month;

--total,average,Variance,standarddeviation of Recovered--
SELECT 
    YEAR(Date_converted) AS Year,
    MONTH(Date_converted) AS Month,
    SUM(Recovered_no) AS Total,
    AVG(Recovered_no) AS Average,
    STDEV(Recovered_no) AS StandardDeviation,
    (STDEV(Recovered_no) * STDEV(Recovered_no)) AS Variance
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date_converted), MONTH(Date_converted)
ORDER BY Year, Month;
-- country with the highest number of  confirmed cases--
SELECT TOP(1) 
    Country_Region,
    SUM(Confirmed_no) AS TotalConfirmed
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY TotalConfirmed DESC;
-- country with the Lowest number of  death cases--
SELECT TOP(1) 
    Country_Region,
    SUM(Deaths_no) AS Totaldeath
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY Totaldeath	ASC;
-- countries with the recovered cases--
SELECT TOP(5) 
    Country_Region,
    SUM(Recovered_no) AS recoveredcases
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY recoveredcases	DESC;
