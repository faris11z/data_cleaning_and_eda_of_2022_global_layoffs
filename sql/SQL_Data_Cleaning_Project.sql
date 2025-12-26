-- Data Cleaning Project

USE world_layoffs;

-- Inspecting Raw Data
SELECT *
FROM layoffs
;

-- Creating a stgaing table so I dont alter the original table
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Checking new table
SELECT *
FROM layoffs_staging;

-- Removing Duplicates

SELECT *
FROM layoffs_staging;

-- Checking for duplicate records using ROW_NUMBER
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num #Using all relevant columns to ensure no valid data is incorrectly removed
FROM layoffs_staging;

-- Identifying duplicates using a CTE
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT*
FROM duplicate_cte
WHERE row_num>1;

-- Verifying 'Casper'
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- Attempting to delete duplicates using CTE
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num>1;

-- This actually gives an error 
-- Solution: create a new staging table with a row_num column

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging;

-- Insert data into new staging table with row numbers
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Remove duplicate records
SELECT *
FROM layoffs_staging2
WHERE row_num>1;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

-- Dataset without duplicates
SELECT *
FROM layoffs_staging2;


-- Standardize the Data

-- Trim extra spaces from company names
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company =TRIM(company);

-- Standardize industry names with irregularities
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Check Distinct industry names
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT COUNTRY
FROM layoffs_staging2
ORDER BY 1;

-- Found Trailing Dots
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER by 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country like 'united states%' ;

-- Convert string dates to proper DATE type
-- Check existing format first
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2
;
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y')
;
SELECT *
FROM layoffs_staging2
;

-- Alter column type to DATE for proper date operations
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
;

-- Handling Null Values/ Blank Values

-- Identify rows where both layoff counts are missing
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

-- Standardize blank industry entries to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';
;

-- Verify industry nulls
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
;

-- Manual check
SELECT *
FROM layoffs_staging2
WHERE company like 'airbnb'
;

-- Fill missing industry values by referencing other entries of the same company
-- If one row has missing industry but another row of the same company has it, fill it in
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN  layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

UPDATE layoffs_staging2 t1
JOIN  layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry is null )
and t2.industry is not null
;


SELECT *
FROM layoffs_staging2
WHERE company like 'bally%'
;


SELECT *
FROM layoffs_staging2
;
-- Remove Irrelevant Rows and Columns

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;


SELECT *
FROM layoffs_staging2
;
-- row_num is basically not useful
ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;

-- Dataset cleaned for Analysis
SELECT * 
FROM layoffs_staging2;