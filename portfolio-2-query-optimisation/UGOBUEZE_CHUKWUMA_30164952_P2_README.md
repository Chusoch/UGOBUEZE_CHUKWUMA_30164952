# Inventory and Supply Chain Management System — SQL queries

## 1. Show related purchase_order, supplier, warehouse, item records (up to 20).

```sql
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
```

| purchase_order_purchase_order_id | purchase_order_order_number | supplier_supplier_id | supplier_supplier_code | warehouse_warehouse_id | warehouse_code | item_item_id | item_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 50 | PO-2026-001 | 30 | SUP-A | 10 | WH-A | 20 | SKU-A |

## 2. Find stock_event records where event_date matches "2026-10-10" (up to 20).

```sql
SELECT * FROM portfolio."stock_event"
WHERE "event_date" IS NOT DISTINCT FROM '2026-10-10'
ORDER BY "stock_event_id"
LIMIT 20;
```

| stock_event_id | item_id | warehouse_id | source_warehouse_id | purchase_order_id | event_type | quantity | event_date |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 60 | 20 | 10 | NULL | 50 | receipt | 12 | 2026-10-10 |

## 3. Count stock_event records for each item_id (up to 20 groups).

```sql
SELECT "item_id", count(*) AS record_count
FROM portfolio."stock_event"
GROUP BY "item_id"
ORDER BY record_count DESC, "item_id" NULLS LAST
LIMIT 20;
```

| item_id | record_count |
| --- | --- |
| 20 | 1 |
| 21 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.939 | 0.939, 1.038, 0.936 | Sort → Seq Scan | 112 |
| After index | 0.203 | 0.172, 0.203, 0.237 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.939 ms to 0.203 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.913..0.915 rows=20 loops=1)
  Seq Scan on stock_event (actual time=0.014..0.88 rows=20 loops=1)
Planning Time: 0.317 ms
Execution Time: 0.939 ms
```

### Before index, run 2

```text
Sort (actual time=1.012..1.014 rows=20 loops=1)
  Seq Scan on stock_event (actual time=0.014..0.978 rows=20 loops=1)
Planning Time: 0.329 ms
Execution Time: 1.038 ms
```

### Before index, run 3

```text
Sort (actual time=0.912..0.913 rows=20 loops=1)
  Seq Scan on stock_event (actual time=0.014..0.877 rows=20 loops=1)
Planning Time: 0.347 ms
Execution Time: 0.936 ms
```

### After index, run 1

```text
Sort (actual time=0.13..0.131 rows=20 loops=1)
  Bitmap Heap Scan on stock_event (actual time=0.025..0.095 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=20 loops=1)
Planning Time: 0.544 ms
Execution Time: 0.172 ms
```

### After index, run 2

```text
Sort (actual time=0.123..0.124 rows=20 loops=1)
  Bitmap Heap Scan on stock_event (actual time=0.025..0.089 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=20 loops=1)
Planning Time: 0.534 ms
Execution Time: 0.203 ms
```

### After index, run 3

```text
Sort (actual time=0.168..0.169 rows=20 loops=1)
  Bitmap Heap Scan on stock_event (actual time=0.032..0.097 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.66 ms
Execution Time: 0.237 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run UGOBUEZE_CHUKWUMA_30164952_P2_Queries.sql, then UGOBUEZE_CHUKWUMA_30164952_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/UGOBUEZE_CHUKWUMA_30164952_P2_QueryResults.png) · [Index comparison](screenshots/UGOBUEZE_CHUKWUMA_30164952_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

