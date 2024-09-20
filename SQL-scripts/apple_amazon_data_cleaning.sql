-- --------------------------------------------------------------------------------------------------------------------------------------------
-- Amazon Products - Data Cleaning 
-- --------------------------------------------------------------------------------------------------------------------------------------------

-- 1.) Create Staging Table 

CREATE TABLE amazon_products_staging
SELECT *, ROW_NUMBER() OVER() as id
FROM amazon_products
;

SELECT *
FROM amazon_products_staging
;

-- 2.) Update column names

ALTER TABLE amazon_products_staging
CHANGE Title product_name VARCHAR(255),
CHANGE Price price VARCHAR(255),
CHANGE `List Price` list_price VARCHAR(255),
CHANGE Delivery delivery_type VARCHAR(255)
;

SELECT *
FROM amazon_products_staging
;

-- 3.) Format product_name (concatenate)

SELECT product_name, 
SUBSTRING(product_name, 1, LOCATE(')', product_name))
FROM amazon_products_staging
;

UPDATE amazon_products_staging
SET product_name = SUBSTRING(product_name, 1, LOCATE(')', product_name))
;

-- 3.2) Further format macbooks, apple watches and other products

SELECT product_name,
CONCAT(
SUBSTRING(product_name, 1, LOCATE('with', product_name) - 2),
SUBSTRING(product_name, LOCATE(',', product_name, LOCATE(',', product_name) + 1))
) as new_prod
FROM amazon_products_staging
WHERE product_name LIKE '%MacBook%'
;

UPDATE amazon_products_staging
SET product_name = CONCAT(
		SUBSTRING(product_name, 1, LOCATE('with', product_name) - 2),
		SUBSTRING(product_name, LOCATE(',', product_name, LOCATE(',', product_name) + 1))
	)
WHERE product_name LIKE '%MacBook%'
;

SELECT *
FROM amazon_products_staging
;

-- 4. Format price and list_price to be suitable decimal values

-- 4.1 price
SELECT price,
REPLACE(price, ',', '')
FROM amazon_products_staging
;

UPDATE amazon_products_staging
SET price = REPLACE(price, ',', '')
;

UPDATE amazon_products_staging
SET price = REPLACE(price, '.', '')
;

SELECT *
FROM amazon_products_staging
;

-- 4.2 list_price

SELECT list_price,
SUBSTRING(list_price, LOCATE('R', list_price, LOCATE('R', list_price) + 2))
FROM amazon_products_staging
;

UPDATE amazon_products_staging
SET list_price = SUBSTRING(list_price, LOCATE('R', list_price, LOCATE('R', list_price) + 2))
;

UPDATE amazon_products_staging
SET list_price = REPLACE(list_price, 'R', '')
;

UPDATE amazon_products_staging
SET list_price = REPLACE(list_price, ',', '')
;

UPDATE amazon_products_staging
SET list_price = TRIM(list_price)
;

UPDATE amazon_products_staging
SET list_price = price
WHERE list_price = ''
;

-- 5. delivery_type 

UPDATE amazon_products_staging
SET delivery_type = 'Express'
WHERE delivery_type LIKE 'tomorrow%'
;

UPDATE amazon_products_staging
SET delivery_type = 'Standard'
WHERE delivery_type != 'Express'
;

-- 6. Remove non-Apple related products

DELETE FROM amazon_products_staging
WHERE product_name NOT LIKE 'Apple%'
;

-- 7. To remove duplicates we must drop our primary key and re-create it again

ALTER TABLE amazon_products_staging
DROP COLUMN id
;

-- 7.1 Identify duplicates

SELECT *
FROM amazon_products_staging
;

CREATE TABLE amazon_products_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY product_name, price, list_price, delivery_type) as duplicates
FROM amazon_products_staging
;

SELECT *
FROM amazon_products_staging2
ORDER BY 5 DESC
;

-- 7.2 Remove duplicates

DELETE FROM amazon_products_staging2
WHERE duplicates > 1
;

SELECT *
FROM amazon_products_staging2
ORDER BY duplicates DESC
;

ALTER TABLE amazon_products_staging2
DROP COLUMN duplicates
;

-- 8. Update data types

ALTER TABLE amazon_products_staging2
MODIFY product_name VARCHAR(255);

ALTER TABLE amazon_products_staging2
MODIFY price DOUBLE(10, 2);

ALTER TABLE amazon_products_staging2
MODIFY list_price DOUBLE(10, 2);

ALTER TABLE amazon_products_staging2
MODIFY delivery_type VARCHAR(255);

SELECT *
FROM amazon_products
;

-- 9. TRIM brackets for normalization 

SELECT *
FROM amazon_products_staging2
;

SELECT product_name,
CONCAT(
	SUBSTRING(product_name, 1, LOCATE('(', product_name)),
    REPLACE(SUBSTRING(product_name, LOCATE('(', product_name) + 1), ' ', '')
)
FROM amazon_products_staging2
WHERE product_name LIKE 'Apple iPhone%'
;

UPDATE amazon_products_staging2
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('(', product_name)),
    REPLACE(SUBSTRING(product_name, LOCATE('(', product_name) + 1), ' ', '')
)
WHERE product_name LIKE 'Apple iPhone%'
;

-- Extra Step - Normalize further to match other tables 

SELECT product_name,
REPLACE(product_name, 'Unified Memory', '')
FROM amazon_products_staging2
;

UPDATE amazon_products_staging2
SET product_name = REPLACE(product_name, 'Unified Memory', '')
;

SELECT *
FROM incredible_connection_products_staging2
;

DELETE FROM amazon_products_staging2
WHERE product_name LIKE '%studio%'
;































