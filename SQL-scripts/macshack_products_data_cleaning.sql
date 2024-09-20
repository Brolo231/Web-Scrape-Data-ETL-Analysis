-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- macshack_products data cleaning
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. Create staging table

DROP TABLE IF EXISTS macshack_products_staging;
CREATE TABLE macshack_products_staging AS 
SELECT *
FROM macshack_products
;

SELECT *
FROM macshack_products_staging
;

-- 2. Change column names

ALTER TABLE macshack_products_staging
CHANGE Title product_name VARCHAR(255),
CHANGE Price price VARCHAR(255),
CHANGE `List Price` list_price VARCHAR(255),
CHANGE Delivery delivery_type VARCHAR(255)
;

-- 3. Remove new products (Pre-owned only database)

DELETE FROM macshack_products_staging
WHERE product_name LIKE '%New%'
;

-- 4. Normalize product_name

-- 4.1 Apple iPhone 

UPDATE macshack_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('GB', product_name) + 1),
    ')'
)
WHERE product_name LIKE 'Apple iPhone%'
;

-- 4.2 Apple MacBook 

UPDATE macshack_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, LOCATE('A', product_name), 17),
    ' (',
    SUBSTRING(product_name, LOCATE('-', product_name) - 2, 3),
    'inch, Apple ',
    SUBSTRING(product_name, LOCATE('inch', product_name) + 5, 2),
    ' chip, ',
    TRIM(REPLACE(SUBSTRING(product_name, LOCATE('GB', product_name) - 2, 4), '(', '')),
    ', ',
    TRIM(REPLACE(SUBSTRING(product_name, LOCATE('SSD', product_name) - 6, 5), ',', '')),
    ')'
)
WHERE product_name LIKE '%MacBook%'
;

-- 4.3 Apple Watch

UPDATE macshack_products_staging
SET product_name = CONCAT(
	SUBSTRING(product_name, 1, LOCATE('(', product_name) -1),
    '(GPS + Cellular ',
    SUBSTRING(product_name, LOCATE('(', product_name) + 1, 4),
    ')'
)
WHERE product_name LIKE '%watch%'
;

SELECT *
FROM macshack_products_staging
;

-- 5. Remove iMac products

DELETE FROM macshack_products_staging
WHERE product_name LIKE '2021%'
;

-- 6. Normalize and update data types for price and list_price

-- 6.1 price

UPDATE macshack_products_staging
SET price = TRIM(REPLACE(REPLACE(REPLACE(price, 'R', ''), ',', ''), 'inc. VAT', '' ))
;

-- 6.2 list_price

UPDATE macshack_products_staging
SET list_price = TRIM(REPLACE(REPLACE(list_price, 'R', ''), ',', ''))
;

-- 7. Update Delivery Type

UPDATE macshack_products_staging
SET delivery_type = 'Standard'
;

-- 8. Update Data types of price and list price

ALTER TABLE macshack_products_staging
MODIFY price DECIMAL,
MODIFY list_price DECIMAL
;

-- 9. Remove duplicates

CREATE TABLE macshack_products_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY product_name, price, list_price, delivery_type) as duplicates
FROM macshack_products_staging
;

DELETE FROM macshack_products_staging2
WHERE duplicates > 1
;

ALTER TABLE macshack_products_staging2
DROP COLUMN duplicates
;

SELECT *
FROM macshack_products_staging2
;























