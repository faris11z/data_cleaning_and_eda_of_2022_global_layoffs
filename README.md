# SQL Data Cleaning & Exploration – Layoffs 2022 Dataset

## Description
This project focuses on cleaning, standardizing, and exploring the 2022 Layoffs dataset using MySQL. The goal was to prepare an analysis-ready dataset by removing duplicates, standardizing columns, handling null and blank values, and ensuring proper data types.

Inspired by Alex the Analyst’s bootcamp:  
- Data Cleaning: [YouTube Link](https://youtu.be/4UltKCnnnTA?si=uRxaL7L3iJFBUMyC)  
- Exploratory Data Analysis: [YouTube Link](https://youtu.be/QYd-RtK58VQ?si=NHHS1Ry2yYdz8ujD)

## Dataset
- Source: [Kaggle – Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)  
- Format: CSV  

## Tools & Concepts Used
- MySQL  
- SQL functions:
  - `ROW_NUMBER()` with `PARTITION BY` (duplicate detection)  
  - `TRIM()`, `STR_TO_DATE()`  
  - `UPDATE`, `DELETE`, `ALTER TABLE`  
  - CTEs for temporary calculations  

## Learning Outcomes
- Learned safe data cleaning and standardization techniques in MySQL.  
- Practiced using `ROW_NUMBER()` and window functions for duplicate detection and ranking.  
- Gained experience in preparing datasets for analysis and reporting.  
- Performed exploratory analysis to identify trends and summarize key metrics.
