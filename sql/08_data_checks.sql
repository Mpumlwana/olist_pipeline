-- Data checks. Each check counts the bad rows. 0 bad rows = PASS, 1 or more = FAIL.
-- One check (delivered_have_delivery_date) also has a WARN stamp: up to 8 known bad rows (see Deliverable 3) = WARN, more than 8 = FAIL.

SELECT 'no_duplicate_orders' AS check_name, COUNT(*) AS bad_rows, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS status
FROM (SELECT order_id FROM staging.orders GROUP BY order_id HAVING COUNT(*) > 1) AS repeated
UNION ALL
SELECT 'no_duplicate_items', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM (SELECT order_id, order_item_id FROM warehouse.fact_order_items GROUP BY order_id, order_item_id HAVING COUNT(*) > 1) AS repeated
UNION ALL
SELECT 'no_orphan_fact_rows', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM warehouse.fact_order_items f
WHERE NOT EXISTS (SELECT 1 FROM warehouse.dim_customers c WHERE c.customer_id = f.customer_id)
   OR NOT EXISTS (SELECT 1 FROM warehouse.dim_products p WHERE p.product_id = f.product_id)
   OR NOT EXISTS (SELECT 1 FROM warehouse.dim_sellers s WHERE s.seller_id = f.seller_id)
   OR NOT EXISTS (SELECT 1 FROM warehouse.dim_dates d WHERE d.date_key = f.purchase_date)
UNION ALL
SELECT 'money_matches_staging', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM (SELECT 1 WHERE (SELECT SUM(price) FROM warehouse.fact_order_items) IS DISTINCT FROM (SELECT SUM(price) FROM staging.order_items) OR (SELECT SUM(freight_value) FROM warehouse.fact_order_items) IS DISTINCT FROM (SELECT SUM(freight_value) FROM staging.order_items)) AS mismatch
UNION ALL
SELECT 'no_negative_money', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM warehouse.fact_order_items
WHERE price < 0 OR freight_value < 0
UNION ALL
SELECT 'review_score_1_to_5', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
FROM staging.order_reviews
WHERE review_score NOT BETWEEN 1 AND 5 OR review_score IS NULL
UNION ALL
SELECT 'delivered_have_delivery_date', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' WHEN COUNT(*) <= 8 THEN 'WARN' ELSE 'FAIL' END
FROM staging.orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;
