-- SQL Project - Data Cleaning
-- data source https://www.kaggle.com/datasets/swaptr/layoffs-2022

Select *
FROM World_layoffs.layoffs;

-- create a staging table where all the transformation will take place
CREATE TABLE World_layoffs.layoffs_staging
LIKE World_layoffs.layoffs;

INSERT layoffs_staging
SELECT * FROM World_layoffs.layoffs;

Select *
FROM layoffs_staging;

-- For data cleaning, the following steps will be done
-- 1. Check for duplicates and remove any
-- 2. Standardize data and fix errors
-- 3. Look at null values and see what to do about them
-- 4. remove any columns and rows that are not relevant

-- 1. Removing Duplicates
# Check for duplicates
Select *
FROM layoffs_staging;

-- introduce row numbers to the table since it lacks that extra column
Select company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised,
                ROW_NUMBER() OVER (
                       PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
        FROM 
              World_layoffs.layoffs_staging;
-- Now filter the row_num, any one more than 1 is a duplicate
Select *
FROM (
        Select company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised,
                ROW_NUMBER() OVER (
                       PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
        FROM 
              World_layoffs.layoffs_staging
) dublicates
WHERE 
      row_num > 1;
-- output shows no duplicates. confirm by using the duplicate CTE function
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
        FROM 
              World_layoffs.layoffs_staging
)
Select *
FROM duplicate_cte
WHERE row_num > 1;
-- output shows no duplicates confirmed.

-- 2. Standardize data and fix errors

Select *
FROM World_layoffs.layoffs_staging;
-- lets see if there are any null and empty rows in industry
Select distinct industry
FROM World_layoffs.layoffs_staging
ORDER BY industry;

Select *
FROM World_layoffs.layoffs_staging
WHERE industry IS NULL
OR industry = ''
ORDER BY industry;
-- output shows one company 'Appsmith' has no entry for industry
-- set the blanks to nulls
UPDATE World_layoffs.layoffs_staging
SET industry = null
WHERE industry = '';
-- check to see if there are no nulls
Select *
FROM World_layoffs.layoffs_staging
WHERE industry is NULL
OR industry = ''
ORDER BY industry;
-- encountered an error when setting the blanks to null due to the version of MySQl used
-- Lets move on to standardize other variations
Select distinct industry
FROM World_layoffs.layoffs_staging
ORDER BY industry;
-- Output shows no variations in 'industry'.Lets check in the country
Select *
FROM World_layoffs.layoffs_staging;
Select distinct country 
FROM World_layoffs.layoffs_staging
ORDER BY country;
-- Output shows no variations in 'country'.Lets check the date columns
Select *
FROM World_layoffs.layoffs_staging;
-- use 'str to date' to update the field
UPDATE layoffs_staging
SET `date` = str_to_date(`date`,'%m/%d/%Y');
-- convert the data type
ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;
-- error encountered due to the version of mrsql used.Unable to undo 'safe update mode' in this version
Select *
FROM World_layoffs.layoffs_staging;

-- 3. Look at Null values
-- the null values in 'total_laid_off','percentage_laid_off', and other rows all look normal
-- the null or empty values will not be omitted as they will make further calculations easier in the EDA phase
-- so there is not anything to be changed with the null values

-- 4. Remove any columns and rows that are not needed
SELECT *
FROM World_layoffs.layoffs_staging
WHERE total_laid_off IS NULL;

SELECT *
FROM World_layoffs.layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- output shows no areas where NULL is in these columns
-- If there were any that needed deletion then use,
DELETE FROM World_layoffs.layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- error due to safe update mode on

Select *
FROM World_layoffs.layoffs_staging;
-- END OF DATA CLEANING

