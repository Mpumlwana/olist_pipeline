-- Build the warehouse tables (the star schema) from the staging tables.
-- Safe to run many times: each table is dropped and built again.

-- 1. dim_sellers: one row per seller
DROP TABLE IF EXISTS warehouse.dim_sellers;

CREATE TABLE warehouse.dim_sellers AS
SELECT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM staging.sellers;

ALTER TABLE warehouse.dim_sellers ADD PRIMARY KEY (seller_id);

-- 2. dim_customers: one row per customer_id (one per order-level id)
DROP TABLE IF EXISTS warehouse.dim_customers;

CREATE TABLE warehouse.dim_customers AS
SELECT customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
FROM staging.customers;

ALTER TABLE warehouse.dim_customers ADD PRIMARY KEY (customer_id);

-- 3. dim_products: one row per product, with the English category name added
DROP TABLE IF EXISTS warehouse.dim_products;

CREATE TABLE warehouse.dim_products AS
SELECT p.product_id, p.product_category_name, t.product_category_name_english, p.product_name_lenght AS product_name_length, p.product_description_lenght AS product_description_length, p.product_photos_qty, p.product_weight_g, p.product_length_cm, p.product_height_cm, p.product_width_cm
FROM staging.products p
LEFT JOIN staging.product_category_name_translation t ON t.product_category_name = p.product_category_name;

ALTER TABLE warehouse.dim_products ADD PRIMARY KEY (product_id);

-- 4. dim_dates: one row per calendar day, 2016-01-01 to 2018-12-31
DROP TABLE IF EXISTS warehouse.dim_dates;

CREATE TABLE warehouse.dim_dates AS
SELECT d::date AS date_key, EXTRACT(YEAR FROM d)::integer AS year_number, EXTRACT(QUARTER FROM d)::integer AS quarter_number, EXTRACT(MONTH FROM d)::integer AS month_number, TRIM(TO_CHAR(d, 'Month')) AS month_name, EXTRACT(DAY FROM d)::integer AS day_of_month, EXTRACT(ISODOW FROM d)::integer AS day_of_week, TRIM(TO_CHAR(d, 'Day')) AS day_name, EXTRACT(ISODOW FROM d) IN (6, 7) AS is_weekend
FROM generate_series('2016-01-01'::date, '2018-12-31'::date, interval '1 day') AS d;

ALTER TABLE warehouse.dim_dates ADD PRIMARY KEY (date_key);

-- 5. fact_order_items: one row per item inside an order (the middle of the star)
DROP TABLE IF EXISTS warehouse.fact_order_items;

CREATE TABLE warehouse.fact_order_items AS
SELECT i.order_id, i.order_item_id, o.customer_id, i.product_id, i.seller_id, o.order_purchase_timestamp::date AS purchase_date, o.order_status, i.price, i.freight_value
FROM staging.order_items i
JOIN staging.orders o ON o.order_id = i.order_id;

ALTER TABLE warehouse.fact_order_items ADD PRIMARY KEY (order_id, order_item_id);
