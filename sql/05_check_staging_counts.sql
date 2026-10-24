-- Compare the row counts of every raw table with its staging table.
-- Only 2 tables should differ: the dictionary (71 to 73) and geolocation (1000163 to 738332).

SELECT 'product_category_name_translation' AS table_name, (SELECT COUNT(*) FROM raw.product_category_name_translation) AS raw_rows, (SELECT COUNT(*) FROM staging.product_category_name_translation) AS staging_rows
UNION ALL
SELECT 'sellers', (SELECT COUNT(*) FROM raw.sellers), (SELECT COUNT(*) FROM staging.sellers)
UNION ALL
SELECT 'customers', (SELECT COUNT(*) FROM raw.customers), (SELECT COUNT(*) FROM staging.customers)
UNION ALL
SELECT 'products', (SELECT COUNT(*) FROM raw.products), (SELECT COUNT(*) FROM staging.products)
UNION ALL
SELECT 'order_items', (SELECT COUNT(*) FROM raw.order_items), (SELECT COUNT(*) FROM staging.order_items)
UNION ALL
SELECT 'order_payments', (SELECT COUNT(*) FROM raw.order_payments), (SELECT COUNT(*) FROM staging.order_payments)
UNION ALL
SELECT 'order_reviews', (SELECT COUNT(*) FROM raw.order_reviews), (SELECT COUNT(*) FROM staging.order_reviews)
UNION ALL
SELECT 'orders', (SELECT COUNT(*) FROM raw.orders), (SELECT COUNT(*) FROM staging.orders)
UNION ALL
SELECT 'geolocation', (SELECT COUNT(*) FROM raw.geolocation), (SELECT COUNT(*) FROM staging.geolocation);
