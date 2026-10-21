-- Count the rows in every raw table.
-- Compare these numbers with the COPY output and with the original CSV files.

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM raw.geolocation
UNION ALL
SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM raw.order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM raw.order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM raw.products
UNION ALL
SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM raw.product_category_name_translation;