-- 1.) Create Staging Table with specific column types
CREATE TABLE amazon_products_staging AS
SELECT *, ROW_NUMBER() OVER() AS id
FROM amazon_products;

-- 2.) Update column names to more meaningful names
ALTER TABLE amazon_products_staging
CHANGE Title product_name VARCHAR(255),
CHANGE Price price VARCHAR(255),
CHANGE `List Price` list_price VARCHAR(255),
CHANGE Delivery delivery_type VARCHAR(255);

-- 3.) Clean product_name (concatenate)
UPDATE amazon_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('with', product_name) - 2),
	SUBSTRING(product_name, LOCATE(',', product_name, LOCATE(',', product_name) + 1))
)
WHERE product_name LIKE '%MacBook%';

-- 4.) Format price and list_price to decimal values
-- Clean price
UPDATE amazon_products_staging
SET price = REPLACE(REPLACE(price, ',', ''), 'R', '');

-- Clean list_price
UPDATE amazon_products_staging
SET list_price = TRIM(REPLACE(REPLACE(list_price, ',', ''), 'R', ''))
WHERE list_price IS NOT NULL;

-- Set list_price = price where list_price is missing
UPDATE amazon_products_staging
SET list_price = price
WHERE list_price = '';

-- 5.) Standardize delivery_type based on conditions
UPDATE amazon_products_staging
SET delivery_type = 'Express'
WHERE delivery_type LIKE 'tomorrow%';

UPDATE amazon_products_staging
SET delivery_type = 'Standard'
WHERE delivery_type != 'Express';

-- 6.) Remove non-Apple related products
DELETE FROM amazon_products_staging
WHERE product_name NOT LIKE 'Apple%';

-- 7.) Remove duplicates based on product_name, price, list_price, delivery_type
CREATE TABLE amazon_products_staging2 AS
SELECT *, ROW_NUMBER() OVER(PARTITION BY product_name, price, list_price, delivery_type ORDER BY id) AS duplicate_flag
FROM amazon_products_staging;

DELETE FROM amazon_products_staging2
WHERE duplicate_flag > 1;

-- Drop duplicate column after cleanup
ALTER TABLE amazon_products_staging2
DROP COLUMN duplicate_flag;

-- Sanity check
SELECT * 
FROM amazon_products_staging2
WHERE product_name IS NULL OR price IS NULL OR list_price IS NULL;
