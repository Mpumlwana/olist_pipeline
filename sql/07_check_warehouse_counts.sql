-- Check the warehouse tables: rows in each table against the rows we expect.
-- The two numbers should be equal on every line.

SELECT 'dim_sellers' AS table_name, (SELECT COUNT(*) FROM warehouse.dim_sellers) AS warehouse_rows, (SELECT COUNT(*) FROM staging.sellers) AS expected_rows
UNION ALL
SELECT 'dim_customers', (SELECT COUNT(*) FROM warehouse.dim_customers), (SELECT COUNT(*) FROM staging.customers)
UNION ALL
SELECT 'dim_products', (SELECT COUNT(*) FROM warehouse.dim_products), (SELECT COUNT(*) FROM staging.products)
UNION ALL
SELECT 'dim_dates', (SELECT COUNT(*) FROM warehouse.dim_dates), 1096
UNION ALL
SELECT 'fact_order_items', (SELECT COUNT(*) FROM warehouse.fact_order_items), (SELECT COUNT(*) FROM staging.order_items);
