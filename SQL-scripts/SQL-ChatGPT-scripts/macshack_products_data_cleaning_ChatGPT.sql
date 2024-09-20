-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- macshack_products Data Cleaning
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. Create staging table (Backup and work on a copy of the original data)
DROP TABLE IF EXISTS macshack_products_staging;
CREATE TABLE macshack_products_staging AS 
SELECT * FROM macshack_products;

-- Verify the staging table creation
SELECT * FROM macshack_products_staging;

-- 2. Change column names for consistency and clarity
ALTER TABLE macshack_products_staging
CHANGE Title product_name VARCHAR(255),
CHANGE Price price VARCHAR(255),
CHANGE `List Price` list_price VARCHAR(255),
CHANGE Delivery delivery_type VARCHAR(255);

-- 3. Remove new products (Pre-owned only database)
DELETE FROM macshack_products_staging
WHERE product_name LIKE '%New%';

-- 4. Normalize product_name

-- 4.1 Normalize Apple iPhone product names
UPDATE macshack_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, 1, LOCATE('GB', product_name) + 1),
    ')'
)
WHERE product_name LIKE 'Apple iPhone%';

-- 4.2 Normalize Apple MacBook product names
UPDATE macshack_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, LOCATE('A', product_name), 17), -- Extract 'Apple MacBook Air' part
    ' (',
    SUBSTRING(product_name, LOCATE('-', product_name) - 2, 3), -- Extract screen size
    'inch, Apple ',
    SUBSTRING(product_name, LOCATE('inch', product_name) + 5, 2), -- Extract Apple chip type
    ' chip, ',
    TRIM(REPLACE(SUBSTRING(product_name, LOCATE('GB', product_name) - 2, 4), '(', '')), -- Extract RAM size
    ', ',
    TRIM(REPLACE(SUBSTRING(product_name, LOCATE('SSD', product_name) - 6, 5), ',', '')), -- Extract SSD size
    ')'
)
WHERE product_name LIKE '%MacBook%';

-- 4.3 Normalize Apple Watch product names
UPDATE macshack_products_staging
SET product_name = CONCAT(
    SUBSTRING(product_name, 1, LOCATE('(', product_name) - 1), -- Extract the product name part
    '(GPS + Cellular ',
    SUBSTRING(product_name, LOCATE('(', product_name) + 1, 4), -- Extract the version info
    ')'
)
WHERE product_name LIKE '%watch%';

-- Verify the normalization results
SELECT * FROM macshack_products_staging;

-- 5. Remove iMac products (filter out non-relevant products)
DELETE FROM macshack_products_staging
WHERE product_name LIKE '2021%';

-- 6. Normalize and update data types for price and list_price

-- 6.1 Clean and normalize the price column (remove currency symbols and non-numeric characters)
UPDATE macshack_products_staging
SET price = TRIM(REPLACE(REPLACE(REPLACE(price, 'R', ''), ',', ''), 'inc. VAT', ''));

-- Check for any non-numeric values before conversion
SELECT * 
FROM macshack_products_staging 
WHERE price NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$';

-- 6.2 Clean and normalize the list_price column
UPDATE macshack_products_staging
SET list_price = TRIM(REPLACE(REPLACE(list_price, 'R', ''), ',', ''));

-- Check for non-numeric values in list_price
SELECT * 
FROM macshack_products_staging 
WHERE list_price NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$';

-- 7. Update Delivery Type (set all to 'Standard')
UPDATE macshack_products_staging
SET delivery_type = 'Standard';

-- 8. Update Data types of price and list_price to DECIMAL

ALTER TABLE macshack_products_staging
MODIFY price DECIMAL(10, 2),
MODIFY list_price DECIMAL(10, 2);

-- 9. Remove duplicates (using Common Table Expression (CTE))

WITH ranked_products AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY product_name, price, list_price, delivery_type ORDER BY product_name) AS row_num
    FROM macshack_products_staging
)
DELETE FROM macshack_products_staging
WHERE EXISTS (
    SELECT 1 
    FROM ranked_products rp
    WHERE rp.product_name = macshack_products_staging.product_name
      AND rp.price = macshack_products_staging.price
      AND rp.list_price = macshack_products_staging.list_price
      AND rp.delivery_type = macshack_products_staging.delivery_type
      AND rp.row_num > 1
);

-- Verify the cleaned dataset without duplicates
SELECT * FROM macshack_products_staging;

-- 10. (Optional) Add indexes for improved query performance on frequently used columns
CREATE INDEX idx_product_name ON macshack_products_staging (product_name);
CREATE INDEX idx_price ON macshack_products_staging (price);
