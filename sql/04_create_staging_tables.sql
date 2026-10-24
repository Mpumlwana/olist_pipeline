-- Build the staging tables from the raw tables.
-- Safe to run many times: each table is dropped and built again.
-- The raw tables are never changed.

-- 1. product_category_name_translation
--    71 raw rows + 2 translations we added by hand = 73 rows.
DROP TABLE IF EXISTS staging.product_category_name_translation;

CREATE TABLE staging.product_category_name_translation AS
SELECT product_category_name, product_category_name_english
FROM raw.product_category_name_translation
UNION ALL
SELECT 'portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_preparers'
UNION ALL
SELECT 'pc_gamer', 'pc_gamer';
-- 2. sellers
-- No fixes needed: all 4 columns stay TEXT. A plain copy.
DROP TABLE IF EXISTS staging.sellers;

CREATE TABLE staging.sellers AS
SELECT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM raw.sellers;

-- 3. customers
-- No fixes needed: all 5 columns stay TEXT. A plain copy.
DROP TABLE IF EXISTS staging.customers;

CREATE TABLE staging.customers AS
SELECT customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
FROM raw.customers;

-- 4. products
-- 7 columns become integer. Empty cells stay empty. Column names kept, typos included.
DROP TABLE IF EXISTS staging.products;

CREATE TABLE staging.products AS
SELECT product_id, product_category_name, product_name_lenght::integer AS product_name_lenght, product_description_lenght::integer AS product_description_lenght, product_photos_qty::integer AS product_photos_qty, product_weight_g::integer AS product_weight_g, product_length_cm::integer AS product_length_cm, product_height_cm::integer AS product_height_cm, product_width_cm::integer AS product_width_cm
FROM raw.products;

-- 5. order_items
-- order_item_id becomes integer, shipping_limit_date becomes timestamp, price and freight_value become numeric.
DROP TABLE IF EXISTS staging.order_items;

CREATE TABLE staging.order_items AS
SELECT order_id, order_item_id::integer AS order_item_id, product_id, seller_id, shipping_limit_date::timestamp AS shipping_limit_date, price::numeric AS price, freight_value::numeric AS freight_value
FROM raw.order_items;

-- 6. order_payments
-- payment_sequential and payment_installments become integer, payment_value becomes numeric.
DROP TABLE IF EXISTS staging.order_payments;

CREATE TABLE staging.order_payments AS
SELECT order_id, payment_sequential::integer AS payment_sequential, payment_type, payment_installments::integer AS payment_installments, payment_value::numeric AS payment_value
FROM raw.order_payments;

-- 7. order_reviews
-- review_score becomes integer, the two date columns become timestamp. Comments stay TEXT.
DROP TABLE IF EXISTS staging.order_reviews;

CREATE TABLE staging.order_reviews AS
SELECT review_id, order_id, review_score::integer AS review_score, review_comment_title, review_comment_message, review_creation_date::timestamp AS review_creation_date, review_answer_timestamp::timestamp AS review_answer_timestamp
FROM raw.order_reviews;

-- 8. orders
-- The 5 date columns become timestamp. Empty dates stay empty. The other columns stay TEXT.
DROP TABLE IF EXISTS staging.orders;

CREATE TABLE staging.orders AS
SELECT order_id, customer_id, order_status, order_purchase_timestamp::timestamp AS order_purchase_timestamp, order_approved_at::timestamp AS order_approved_at, order_delivered_carrier_date::timestamp AS order_delivered_carrier_date, order_delivered_customer_date::timestamp AS order_delivered_customer_date, order_estimated_delivery_date::timestamp AS order_estimated_delivery_date
FROM raw.orders;

-- 9. geolocation
-- Exact copies removed. lat and lng become numeric. Points outside the Brazil box get empty lat and lng.
DROP TABLE IF EXISTS staging.geolocation;

CREATE TABLE staging.geolocation AS
SELECT geolocation_zip_code_prefix,
       CASE WHEN geolocation_lat::numeric BETWEEN -34 AND 6 AND geolocation_lng::numeric BETWEEN -74 AND -34 THEN geolocation_lat::numeric END AS geolocation_lat,
       CASE WHEN geolocation_lat::numeric BETWEEN -34 AND 6 AND geolocation_lng::numeric BETWEEN -74 AND -34 THEN geolocation_lng::numeric END AS geolocation_lng,
       geolocation_city,
       geolocation_state
FROM (SELECT DISTINCT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state FROM raw.geolocation) AS unique_rows;
