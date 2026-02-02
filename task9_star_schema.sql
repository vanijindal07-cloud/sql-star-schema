CREATE DATABASE superstore;
USE superstore;


SELECT * FROM global_superstore;


CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);


INSERT INTO dim_customer (customer_id, customer_name, segment)
SELECT DISTINCT
    `Customer ID`,
    `Customer Name`,
    Segment
FROM global_superstore;

SELECT * FROM dim_customer LIMIT 10;




CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50),
    product_name VARCHAR(150),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

INSERT INTO dim_product (product_id, product_name, category, sub_category)
SELECT DISTINCT
    `Product ID`,
    `Product Name`,
    Category,
    `Sub-Category`
FROM global_superstore;

SELECT * FROM dim_product LIMIT 10;




CREATE TABLE dim_region (
    region_key INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO dim_region (city, state, country, region)
SELECT DISTINCT
    City,
    State,
    Country,
    Region
FROM global_superstore;

SELECT * FROM dim_region LIMIT 10;




CREATE TABLE dim_date (
    date_key INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    order_year INT,
    order_month INT,
    order_day INT
);

INSERT INTO dim_date (order_date, ship_date, order_year, order_month, order_day)
SELECT DISTINCT
    STR_TO_DATE(`Order Date`, '%d-%m-%Y'),
    STR_TO_DATE(`Ship Date`, '%d-%m-%Y'),
    YEAR(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    MONTH(STR_TO_DATE(`Order Date`, '%d-%m-%Y')),
    DAY(STR_TO_DATE(`Order Date`, '%d-%m-%Y'))
FROM global_superstore;

SELECT * FROM dim_date LIMIT 10;








CREATE TABLE fact_sales (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_key INT,
    product_key INT,
    region_key INT,
    date_key INT,
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (region_key) REFERENCES dim_region(region_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

INSERT INTO fact_sales (
    customer_key,
    product_key,
    region_key,
    date_key,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    dc.customer_key,
    dp.product_key,
    dr.region_key,
    dd.date_key,
    gs.Sales,
    gs.Quantity,
    gs.Discount,
    gs.Profit
FROM global_superstore gs
JOIN dim_customer dc
    ON gs.`Customer ID` = dc.customer_id
JOIN dim_product dp
    ON gs.`Product ID` = dp.product_id
JOIN dim_region dr
    ON gs.City = dr.city
   AND gs.State = dr.state
   AND gs.Country = dr.country
JOIN dim_date dd
    ON STR_TO_DATE(gs.`Order Date`, '%d-%m-%Y') = dd.order_date;


SELECT COUNT(*) FROM fact_sales;
SELECT * FROM fact_sales LIMIT 10;
TRUNCATE TABLE fact_sales;

INSERT INTO fact_sales (
    customer_key,
    product_key,
    region_key,
    date_key,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    dc.customer_key,
    dp.product_key,
    dr.region_key,
    dd.date_key,
    gs.Sales,
    gs.Quantity,
    gs.Discount,
    gs.Profit
FROM global_superstore gs
LEFT JOIN dim_customer dc
    ON gs.`Customer ID` = dc.customer_id
LEFT JOIN dim_product dp
    ON gs.`Product ID` = dp.product_id
LEFT JOIN dim_region dr
    ON gs.City = dr.city
   AND gs.State = dr.state
   AND gs.Country = dr.country
LEFT JOIN dim_date dd
    ON STR_TO_DATE(gs.`Order Date`, '%d-%m-%Y') = dd.order_date;

SELECT
    r.region,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region;



CREATE INDEX idx_customer ON fact_sales(customer_key);
CREATE INDEX idx_product ON fact_sales(product_key);
CREATE INDEX idx_region ON fact_sales(region_key);
CREATE INDEX idx_date ON fact_sales(date_key);


SELECT
    r.region,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_region r
    ON f.region_key = r.region_key
GROUP BY r.region;
