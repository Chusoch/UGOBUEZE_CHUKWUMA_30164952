-- Show related purchase_order, supplier, warehouse, item records (up to 20).
SELECT t0."purchase_order_id" AS "purchase_order_purchase_order_id",
       t0."order_number" AS "purchase_order_order_number",
       t1."supplier_id" AS "supplier_supplier_id",
       t1."supplier_code" AS "supplier_supplier_code",
       t2."warehouse_id" AS "warehouse_warehouse_id",
       t2."code" AS "warehouse_code",
       t3."item_id" AS "item_item_id",
       t3."sku" AS "item_sku"
FROM portfolio."purchase_order" t0
JOIN portfolio."supplier" t1 ON t0."supplier_id" = t1."supplier_id"
JOIN portfolio."warehouse" t2 ON t0."warehouse_id" = t2."warehouse_id"
JOIN portfolio."item" t3 ON t0."item_id" = t3."item_id"
ORDER BY t0."purchase_order_id", t1."supplier_id", t2."warehouse_id", t3."item_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."purchase_order_id" AS "purchase_order_purchase_order_id",
       t0."order_number" AS "purchase_order_order_number",
       t1."supplier_id" AS "supplier_supplier_id",
       t1."supplier_code" AS "supplier_supplier_code",
       t2."warehouse_id" AS "warehouse_warehouse_id",
       t2."code" AS "warehouse_code",
       t3."item_id" AS "item_item_id",
       t3."sku" AS "item_sku"
FROM portfolio."purchase_order" t0
JOIN portfolio."supplier" t1 ON t0."supplier_id" = t1."supplier_id"
JOIN portfolio."warehouse" t2 ON t0."warehouse_id" = t2."warehouse_id"
JOIN portfolio."item" t3 ON t0."item_id" = t3."item_id"
ORDER BY t0."purchase_order_id", t1."supplier_id", t2."warehouse_id", t3."item_id"
LIMIT 20;

-- Find stock_event records where event_date matches "2026-10-10" (up to 20).
SELECT * FROM portfolio."stock_event"
WHERE "event_date" IS NOT DISTINCT FROM '2026-10-10'
ORDER BY "stock_event_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."stock_event"
WHERE "event_date" IS NOT DISTINCT FROM '2026-10-10'
ORDER BY "stock_event_id"
LIMIT 20;

-- Count stock_event records for each item_id (up to 20 groups).
SELECT "item_id", count(*) AS record_count
FROM portfolio."stock_event"
GROUP BY "item_id"
ORDER BY record_count DESC, "item_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "item_id", count(*) AS record_count
FROM portfolio."stock_event"
GROUP BY "item_id"
ORDER BY record_count DESC, "item_id" NULLS LAST
LIMIT 20;
