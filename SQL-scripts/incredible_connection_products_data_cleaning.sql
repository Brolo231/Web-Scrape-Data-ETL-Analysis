-- --------------------------------------------------------------------------------------------------------------------------------------------
-- incredible_connection_products data cleaning
-- --------------------------------------------------------------------------------------------------------------------------------------------

-- 1.) Create Staging Table with specific column types

CREATE TABLE incredible_connection_products_staging AS
SELECT *
FROM incredible_connection_products
;

-- 2.) Update column names to more meaningful names

SELECT *
FROM incredible_connection_products_staging
;

ALTER TABLE incredible_connection_products_staging
CHANGE COLUMN title product_name VARCHAR(255),
CHANGE COLUMN Price price VARCHAR(255),
CHANGE COLUMN `List Price` list_price VARCHAR(255), 
CHANGE COLUMN Delivery delivery_type VARCHAR(255)
;

-- 3.) Clean product_name (concatenate)

-- 3.1 iPhone cleaning

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('GB', product_name) - 4)),
    '(',
    TRIM(SUBSTRING(product_name, LOCATE('GB', product_name, LOCATE(' ', product_name)) -3, 5)), 
    ')'
    
--     SUBSTRING(product_name, LOCATE('GB', product_name, LOCATE(' ', product_name)) -3), 
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple iPhone%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('GB', product_name) - 4)),
    '(',
    TRIM(SUBSTRING(product_name, LOCATE('GB', product_name, LOCATE(' ', product_name)) -3, 5)), 
    ')'
    
--     SUBSTRING(product_name, LOCATE('GB', product_name, LOCATE(' ', product_name)) -3), 
)
WHERE product_name LIKE 'Apple iPhone%'
;

-- 3.2 Macbook cleaning

SELECT *
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple MacBook%'
;

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE('1', product_name) -1),
    '(',
    SUBSTRING(product_name, LOCATE('1', product_name), 2),
    '-inch, Apple ',
    SUBSTRING(product_name, LOCATE('M', product_name, LOCATE('M', product_name) + 1), 2),
    ' chip, ',
    SUBSTRING(product_name, LOCATE('GB', product_name) -2, 4),
    ', ',
	SUBSTRING(product_name, LOCATE('GB', product_name, LOCATE('GB', product_name) +1) -3, 5),
    ')'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple MAcBook%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('1', product_name) -1),
    '(',
    SUBSTRING(product_name, LOCATE('1', product_name), 2),
    '-inch, Apple ',
    SUBSTRING(product_name, LOCATE('M', product_name, LOCATE('M', product_name) + 1), 2),
    ' chip, ',
    SUBSTRING(product_name, LOCATE('GB', product_name) -2, 4),
    ', ',
	SUBSTRING(product_name, LOCATE('GB', product_name, LOCATE('GB', product_name) +1) -3, 5),
    ')'
)
WHERE product_name LIKE 'Apple MAcBook%'
;

-- 3.3 Apple watch cleaning
-- 3.3.1 Apple Watch SE

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE('SE', product_name) + 1),
    ' (2nd Gen, 2023)'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch SE %'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('SE', product_name) + 1),
    ' (2nd Gen, 2023)'
)
WHERE product_name LIKE 'Apple Watch SE %'
;

-- 3.3.2 Apple Watch Series

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('Series', product_name)) + 2),
    ' (GPS + Cellular',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch Series%' AND product_name LIKE '%Cellular%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('Series', product_name)) + 2),
    ' (GPS + Cellular',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
WHERE product_name LIKE 'Apple Watch Series%' AND product_name LIKE '%Cellular%'
;

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('Series', product_name)) + 2),
    ' (GPS',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch Series%' AND product_name NOT LIKE '%Cellular%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE(' ', product_name, LOCATE('Series', product_name)) + 2),
    ' (GPS',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
WHERE product_name LIKE 'Apple Watch Series%' AND product_name NOT LIKE '%Cellular%'
;

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE('S', product_name)),
    'eries ',
    SUBSTRING(product_name, LOCATE('S', product_name) + 1, 1),
    ' (GPS + Cellular',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch S%' AND product_name LIKE '%Cellular%' AND product_name NOT LIKE 'Apple Watch SE (%' AND product_name NOT LIKE 'Apple Watch Series%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('S', product_name)),
    'eries ',
    SUBSTRING(product_name, LOCATE('S', product_name) + 1, 1),
    ' (GPS + Cellular',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
WHERE product_name LIKE 'Apple Watch S%' AND product_name LIKE '%Cellular%' AND product_name NOT LIKE 'Apple Watch SE (%' AND product_name NOT LIKE 'Apple Watch Series%'
;

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE('S', product_name)),
    'eries ',
    SUBSTRING(product_name, LOCATE('S', product_name) + 1, 1),
    ' (GPS',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch S%' AND product_name NOT LIKE '%Cellular%' AND product_name NOT LIKE 'Apple Watch SE (%' AND product_name NOT LIKE 'Apple Watch Series%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('S', product_name)),
    'eries ',
    SUBSTRING(product_name, LOCATE('S', product_name) + 1, 1),
    ' (GPS',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
WHERE product_name LIKE 'Apple Watch S%' AND product_name NOT LIKE '%Cellular%' AND product_name NOT LIKE 'Apple Watch SE (%' AND product_name NOT LIKE 'Apple Watch Series%'
;

SELECT *
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch%'
;

-- 3.3.3 Apple Watch Ultra

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE('Ultra', product_name) + 4),
    ' (GPS + Cellular',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
FROM incredible_connection_products_staging
WHERE product_name LIKE 'Apple Watch Ultra%' AND product_name NOT LIKE 'Apple Watch SE (%' AND product_name NOT LIKE 'Apple Watch Series%'
;

UPDATE incredible_connection_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('Ultra', product_name) + 4),
    ' (GPS + Cellular',
    SUBSTRING(product_name, LOCATE('mm', product_name) - 3, 5),
    ')'
)
WHERE product_name LIKE 'Apple Watch Ultra%' AND product_name NOT LIKE 'Apple Watch SE (%' AND product_name NOT LIKE 'Apple Watch Series%'
;

-- 4.) Format price and list_price to decimal values

-- Clean price

SELECT price,
CONCAT(
	REPLACE(SUBSTRING(price, LOCATE('R ', price) + 2), ',', '.')
)
FROM incredible_connection_products_staging
;

UPDATE incredible_connection_products_staging
SET price = CONCAT(
	REPLACE(SUBSTRING(price, LOCATE('R ', price) + 2), ',', '.')
)
;

UPDATE incredible_connection_products_staging
SET price = REPLACE(price, '.', '')
;

DELETE FROM incredible_connection_products_staging
WHERE price LIKE '%A%'
;

ALTER TABLE incredible_connection_products_staging
MODIFY price DECIMAL
;

-- Clean list_price

SELECT *
FROM incredible_connection_products_staging
;

SELECT list_price,
CONCAT(
	REPLACE(SUBSTRING(list_price, LOCATE('R ', list_price, LOCATE('Price', list_price)) + 2), ',', '')
)
FROM incredible_connection_products_staging
WHERE list_price LIKE 'Regular%'
;

UPDATE incredible_connection_products_staging
SET list_price = CONCAT(
	REPLACE(SUBSTRING(list_price, LOCATE('R ', list_price, LOCATE('Price', list_price)) + 2), ',', '')
)
WHERE list_price LIKE 'Regular%'
;

ALTER TABLE incredible_connection_products_staging
MODIFY list_price DECIMAL
;

-- Set list_price = price where list_price is missing

UPDATE incredible_connection_products_staging
SET list_price = price 
WHERE list_price LIKE '%N/A%'
;

-- 5.) Standardize delivery_type based on conditions

SELECT *
FROM incredible_connection_products_staging
;

UPDATE incredible_connection_products_staging
SET delivery_type = 'Standard'
;

-- 6.) Remove non-Apple related products

DELETE FROM incredible_connection_products_staging
WHERE product_name NOT LIKE '%(%'
;

SELECT *
FROM incredible_connection_products_staging2
WHERE product_name LIKE '%rey%' OR product_name LIKE '%ver%' OR product_name LIKE '%ght%' OR product_name LIKE '%SB%' OR product_name LIKE '%B B%'   
;

DELETE FROM incredible_connection_products_staging2
WHERE product_name LIKE '%rey%' OR product_name LIKE '%ver%' OR product_name LIKE '%ght%' OR product_name LIKE '%SB%' OR product_name LIKE '%B B%'   
; 

-- 7.) Remove duplicates based on product_name, price, list_price, delivery_type

CREATE TABLE incredible_connection_products_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY product_name, price, list_price, delivery_type) as duplicates
FROM incredible_connection_products_staging
;

SELECT *
FROM incredible_connection_products_staging2
;

DELETE FROM incredible_connection_products_staging2
WHERE duplicates > 1
;

-- Drop duplicate column after cleanup

ALTER TABLE incredible_connection_products_staging2
DROP COLUMN duplicates
;

-- Sanity check

SELECT *
FROM incredible_connection_products_staging2
;















































