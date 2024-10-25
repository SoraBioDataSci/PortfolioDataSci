Select *
FROM Walmart_sales.`walmartsalesdata.csv`csv;

-- EDA (Explore the data,find trends and patterns,look for outliers,detect relationships between variables)
-- 1)Understand the structure of the dataset
-- a)Check the data types of the columns
Select *
FROM Walmart_sales.`walmartsalesdata.csv`csv LIMIT 10;
SHOW COLUMNS FROM Walmart_sales.`walmartsalesdata.csv`;
DESCRIBE Walmart_sales.`walmartsalesdata.csv`;
-- b)Check for missing values
SELECT
  SUM(CASE WHEN `Invoice ID` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Branch` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `City` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Customer type` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Gender` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Product line` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Unit price` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Quantity` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Tax 5%` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Total` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Date` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Time` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Payment` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `cogs` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `gross margin percentage` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `gross income` IS NULL THEN 1 ELSE 0 END) +
  SUM(CASE WHEN `Rating` IS NULL THEN 1 ELSE 0 END) AS `Total_missing_values`
FROM Walmart_sales.`walmartsalesdata.csv`;
-- output shows 0 missing values in all columns

-- 2)Basic Statistical Summary
-- a)calculate the summary statistics for numerical columns like quantity,total etc
SELECT 
   AVG(Quantity), 
   AVG(Total), 
   AVG(rating), 
   MIN(Rating), 
   MAX(Rating)
FROM Walmart_sales.`walmartsalesdata.csv`;
-- b)count distinct values for categorical variables like branch,city etc
SELECT Branch, COUNT(*) FROM Walmart_sales.`walmartsalesdata.csv`GROUP BY Branch;

-- 3)Sales Trends over time
-- a)Analyze/aggregate the sales by date
SELECT DATE(Date), SUM(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY DATE(Date);
-- output shows the highest sales dates are in the first 3 months(Jan-March)
-- b)Check for any patterns in sales based on the Time column.Are certain hours busier than others?
SELECT HOUR(TIME(Time)), SUM(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY HOUR(TIME(Time));
-- c) check for any patterns in sales based on day of the week
SELECT DAYOFWEEK(Date), SUM(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY DAYOFWEEK(Date);

-- 4)Customer Demographics
-- a)How does the customer type affect the sales or quantity purchased
SELECT 
  `Customer type`, 
  SUM(`Total`) AS `Total_Sales`
FROM Walmart_sales.`walmartsalesdata.csv`
GROUP BY `Customer type`;
-- b)Check if there's any significant difference in purchasing behavior between genders
SELECT Gender, AVG(Total), AVG(Quantity), COUNT(*) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY Gender;

-- 5)Product line analysis
-- a)which product line generates the most revenue
SELECT `Product line`, SUM(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY `product line` ORDER BY SUM(Total) DESC;
-- b)check if certain product lines lead to large quantities sold
SELECT `Product line`, AVG(Quantity) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY `Product line` ORDER BY AVG(Quantity) DESC;

-- 6)Branch and City analysis
-- a)Compare the branches and their performances
SELECT Branch, SUM(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY Branch;
-- b)Compare the cities and their sales
SELECT City, SUM(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY City;

-- 7)Payment method analysis
-- a)check which payment method is mostly used
SELECT Payment, COUNT(*) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY Payment;
-- b)check if different payment methods are linked to different average order values
SELECT Payment, AVG(Total) FROM  Walmart_sales.`walmartsalesdata.csv` GROUP BY Payment;

-- 8)Profitability
-- a)Analyze the profitability using the 'gross margin percentage' and 'gross income columns'.
SELECT AVG(`gross margin percentage`), AVG(`gross income`) FROM Walmart_sales.`walmartsalesdata.csv`;
-- b)Check which branch is most profitable based on gross income
SELECT Branch, SUM(`gross income`) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY Branch ORDER BY SUM(`gross income`) DESC;

-- 9)Customer Rating
-- a)Understand how customers rated their experience
SELECT Rating, COUNT(*) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY Rating ORDER BY Rating DESC;
-- b)Do higher ratings have higher totals
SELECT Rating, AVG(Total) FROM Walmart_sales.`walmartsalesdata.csv` GROUP BY Rating ORDER BY Rating;










