-- --------------------------------------------------------------------------------------------------------------------------------------------
-- incredible_connection_products data cleaning
-- --------------------------------------------------------------------------------------------------------------------------------------------

-- 1.) Create Staging Table with specific column types

CREATE TABLE incredible_connection_products_staging AS
SELECT *
FROM incredible_connection_products;

-- 2.) Update column names to more meaningful names

ALTER TABLE incredible_connection_products_staging
CHANGE COLUMN title product_name VARCHAR(255),
CHANGE COLUMN Price price VARCHAR(255),
CHANGE COLUMN `List Price` list_price VARCHAR(255), 
CHANGE COLUMN Delivery delivery_type VARCHAR(255);

-- 3.) Clean product_name (concatenate)

-- 3.1 iPhone cleaning

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('GB', product_name) - 4)),
    ' (',
    TRIM(SUBSTRING(product_name, LOCATE('GB', product_name) - 3, 5)), 
    ')'
)
WHERE product_name LIKE 'Apple iPhone%';

-- 3.2 Macbook cleaning

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, 1, LOCATE('1', product_name) -1),
    '(Apple ', 
    SUBSTRING(product_name, LOCATE('M', product_name), 2), ' chip, ',
    SUBSTRING(product_name, LOCATE('GB', product_name) - 2, 4), ')'
)
WHERE product_name LIKE 'Apple MacBook%';

-- 3.3 Apple watch cleaning (generalized for SE, Series, Ultra)

-- SE Cleaning
UPDATE incredible_connection_products_staging
SET product_name = CONCAT(SUBSTRING(product_name, 1, LOCATE('SE', product_name) + 2), ' (2nd Gen, 2023)')
WHERE product_name LIKE 'Apple Watch SE %';

-- Series (Cellular and GPS versions)
UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, 1, LOCATE('Series ', product_name) + 6),
    IF(product_name LIKE '%Cellular%', ' (GPS + Cellular', ' (GPS'),
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5), ')'
)
WHERE product_name LIKE 'Apple Watch Series%';

-- Ultra Cleaning
UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, 1, LOCATE('Ultra', product_name) + 4),
    ' (GPS + Cellular', 
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5), ')'
)
WHERE product_name LIKE 'Apple Watch Ultra%';

-- 4.) Clean and format price and list_price as DECIMAL values

-- Clean price
UPDATE incredible_connection_products_staging
SET price = REPLACE(SUBSTRING(price, LOCATE('R ', price) + 2), ',', '.');

-- Clean list_price
UPDATE incredible_connection_products_staging
SET list_price = REPLACE(SUBSTRING(list_price, LOCATE('R ', list_price) + 2), ',', '')
WHERE list_price LIKE 'Regular%';

-- Set list_price = price where list_price is missing
UPDATE incredible_connection_products_staging
SET list_price = price
WHERE list_price IS NULL OR list_price LIKE '%N/A%';

-- Alter columns to DECIMAL
ALTER TABLE incredible_connection_products_staging
MODIFY price DECIMAL(10, 2),
MODIFY list_price DECIMAL(10, 2);

-- 5.) Standardize delivery_type

UPDATE incredible_connection_products_staging
SET delivery_type = 'Standard';

-- 6.) Remove non-Apple related products

DELETE FROM incredible_connection_products_staging
WHERE product_name NOT LIKE '%(%';

-- 7.) Remove duplicates based on product_name, price, list_price, delivery_type

WITH duplicates_cte AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY product_name, price, list_price, delivery_type) AS row_num
    FROM incredible_connection_products_staging
)
DELETE FROM incredible_connection_products_staging
WHERE product_name IN (
    SELECT product_name
    FROM duplicates_cte
    WHERE row_num > 1
);

-- Sanity check
SELECT * FROM incredible_connection_products_staging;
