-- Exploratory Data Analysis

-- Here i will explore the data and find trends or anything interesting like outliers
-- Basically going to look around and see what I find

Select *
FROM World_layoffs.layoffs_staging;

-- EASY QUERIES
-- Will start by looking at the 'total_laid_off' column by checking the maximum value

Select MAX(total_laid_off)
FROM World_layoffs.layoffs_staging;

-- lets look at the percentage to see how big these layoffs were
Select MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM World_layoffs.layoffs_staging
WHERE percentage_laid_off IS NOT NULL;

-- Output shows that one company had 1 which is basically 100% of the company laid off.Lets look at more info on that company.
Select *
FROM World_layoffs.layoffs_staging
WHERE percentage_laid_off = 1;
-- Output shows that they are mostly startups who all went under during this period,mostly in USA
-- If I order by 'funds_raised', I will see how big some of these companies were
Select *
FROM World_layoffs.layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC;
-- Output shows that even companies lile Fisker,Convoy etc that raised over 1 billion, still went under

-- TOUGH QUERIES(mostly use GROUP BY)
-- Which companies had the biggest single layoffs

Select company, total_laid_off
FROM World_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;
-- output is for one single day
-- Which companies had the Most Total layoffs
Select company, SUM(total_laid_off)
FROM World_layoffs.layoffs_staging
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Lets check the date range of the data
Select MIN(`date`), MAX(`date`)
FROM World_layoffs.layoffs_staging;

-- Lets check by industry
Select industry, SUM(total_laid_off)
FROM World_layoffs.layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;
-- output shows that 'transportation and retail were hit really hard,this makes sense due to the lockdown
-- Lets check by country
Select country, SUM(total_laid_off)
FROM World_layoffs.layoffs_staging
GROUP BY country
ORDER BY 2 DESC;
-- ouput shows the USA has by far the biggest hit in layoffs-kenya,nigeria and ghana being the only african counties in the data
-- lets check by date(year)
Select `date`, SUM(total_laid_off)
FROM World_layoffs.layoffs_staging
GROUP BY `date`
ORDER BY 1 DESC;

Select YEAR(`date`), SUM(total_laid_off)
FROM World_layoffs.layoffs_staging
GROUP BY YEAR(`date`)
ORDER BY 1 ASC;
-- output shows that despite being 5 years after the pandemic, 2024 has the largest laid off numbers
-- lets check by the stage of the companies
Select stage, SUM(total_laid_off)
FROM World_layoffs.layoffs_staging
GROUP BY stage
ORDER BY 2 DESC;

-- TOUGHER QUERIES
-- After looking at companies with the most layoffs,lets look at per year

Select YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

WITH Company_Year AS
(
Select company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
)
Select company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
-- output shows in each year, the top three companies with the most laid off staff
-- next lets find the rolling total of layoffs per month
Select SUBSTRING(`date`,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY dates
ORDER BY dates ASC;

-- next I will use the above in a CTE so i can query off of it
WITH DATE_CTE AS
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
-- output shows an added column with rolling total layoffs for each month
-- next lets look at how much each company was laying off per year
Select company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

Select company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
)
Select *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;
-- output shows the companies ranking by total laid off in each year
-- DONE