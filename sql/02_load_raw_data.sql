-- Step 1: empty all raw tables, so this script can be run many times
-- without making duplicate rows.
TRUNCATE TABLE
    raw.customers,
    raw.geolocation,
    raw.orders,
    raw.order_items,
    raw.order_payments,
    raw.order_reviews,
    raw.products,
    raw.sellers,
    raw.product_category_name_translation;

-- Step 2: load every CSV file. The path starts with /data because
-- that is where Docker shows our data folder inside the container.
COPY raw.customers FROM '/data/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.geolocation FROM '/data/olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.orders FROM '/data/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.order_items FROM '/data/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.order_payments FROM '/data/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.order_reviews FROM '/data/olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.products FROM '/data/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.sellers FROM '/data/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY raw.product_category_name_translation FROM '/data/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');