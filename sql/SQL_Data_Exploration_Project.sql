-- Data Exploration

USE world_layoffs;

-- Inspecting Cleaned Data
SELECT *
FROM layoffs_staging2;



-- Maximum number of employees laid off
SELECT MAX(total_laid_off)
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT 
MAX(percentage_laid_off) max_percentage_laid_off,  
MIN(percentage_laid_off) min_percentage_laid_off
FROM layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Companies that laid off completely
SELECT company
FROM layoffs_staging2
WHERE  percentage_laid_off = 1;

-- No. of Companies shut down completely
SELECT count(company) as fully_laid_off_companies
FROM layoffs_staging2
WHERE  percentage_laid_off = 1;

-- Most funded companies that were laid off completely
SELECT company, funds_raised_millions
FROM layoffs_staging2
WHERE  percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- Total layoffs by company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Date Range of Layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Total Layoffs by Industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total Layoffs by Country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- Total Layoffs by Year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Average Percentage of Layoffs per Company
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Monthly Layoff Trends
SELECT 
SUBSTRING(`date`, 1, 7) AS `year_month`,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `year_month`
ORDER BY `year_month` ASC;

-- Rolling Total of Layoffs Over Time
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `year_month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `year_month`
ORDER BY 1 ASC
)
SELECT `year_month`,total_off
, SUM(total_off) OVER(ORDER BY `year_month`) AS rolling_total
FROM Rolling_Total;

-- Total Layoffs by Company and Year
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 Companies by Layoffs per Year
WITH Company_Year(company,years,total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <=5
;