# Task 9 – SQL Data Modeling (Star Schema)

## Dataset
Global Superstore 

## Objective
To design and implement a star schema data model for analytical and business intelligence reporting.

## Tools Used
- MySQL Workbench
- dbdiagram.io

## Schema Design
The schema follows a star structure with one fact table and multiple dimension tables.

### Fact Table
- fact_sales: Stores sales metrics such as sales, quantity, discount, and profit.

### Dimension Tables
- dim_customer: Customer details
- dim_product: Product details
- dim_region: Geographical information
- dim_date: Order and shipping dates

## Steps Performed
1. Imported the Global Superstore dataset into MySQL.
2. Identified fact and dimension tables.
3. Created dimension tables using surrogate primary keys.
4. Created a fact table with foreign key relationships.
5. Loaded distinct records into dimension tables.
6. Inserted transactional data into the fact table using joins.
7. Created indexes on foreign keys to improve query performance.
8. Validated the schema using analytical SQL queries.
9. Designed and exported a star schema diagram.
# i could not make the output analysis csv

## Outcome
Successfully built a star schema suitable for BI reporting and analytical queries.
