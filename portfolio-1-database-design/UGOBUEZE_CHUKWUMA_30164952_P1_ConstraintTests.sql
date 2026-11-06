-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. warehouse pk. Expected: pk_warehouse, SQLSTATE 23505.
INSERT INTO portfolio."warehouse" ("warehouse_id", "code", "name", "location")
VALUES (10, 'WH-X', 'Duplicate ID Warehouse', 'Test Location');

-- 2. warehouse unique. Expected: uq_warehouse_0, SQLSTATE 23505.
INSERT INTO portfolio."warehouse" ("warehouse_id", "code", "name", "location")
VALUES (1001, 'WH-A', 'Unique Conflict Warehouse', 'Test Location');

-- 3. warehouse not null. Expected: code, SQLSTATE 23502.
INSERT INTO portfolio."warehouse" ("warehouse_id", "code", "name", "location")
VALUES (1002, NULL, 'Missing Code Warehouse', 'Test Location');

-- 4. item pk. Expected: pk_item, SQLSTATE 23505.
INSERT INTO portfolio."item" ("item_id", "sku", "name", "unit", "active")
VALUES (20, 'SKU-X', 'Duplicate ID Item', 'each', TRUE);

-- 5. item unique. Expected: uq_item_0, SQLSTATE 23505.
INSERT INTO portfolio."item" ("item_id", "sku", "name", "unit", "active")
VALUES (1003, 'SKU-A', 'Unique Conflict Item', 'each', TRUE);

-- 6. supplier pk. Expected: pk_supplier, SQLSTATE 23505.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_code", "name", "active")
VALUES (30, 'SUP-X', 'Duplicate ID Supplier', TRUE);

-- 7. supplier unique. Expected: uq_supplier_0, SQLSTATE 23505.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_code", "name", "active")
VALUES (1004, 'SUP-A', 'Unique Conflict Supplier', TRUE);

-- 8. inventory pk. Expected: pk_inventory_balance, SQLSTATE 23505.
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at")
VALUES (40, 10, 21, 4, 1, '2026-10-12T12:00:00Z');

-- 9. inventory unique. Expected: uq_inventory_balance_0, SQLSTATE 23505.
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at")
VALUES (1005, 10, 20, 4, 1, '2026-10-12T12:00:00Z');

-- 10. inventory fk warehouse. Expected: fk_inventory_balance_0, SQLSTATE 23503.
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at")
VALUES (1006, 9001, 20, 4, 1, '2026-10-12T12:00:00Z');

-- 11. inventory fk item. Expected: fk_inventory_balance_1, SQLSTATE 23503.
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at")
VALUES (1007, 11, 9002, 4, 1, '2026-10-12T12:00:00Z');

-- 12. inventory check. Expected: inventory_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at")
VALUES (1008, 10, 21, -1, 1, '2026-10-12T12:00:00Z');

-- 13. purchase pk. Expected: pk_purchase_order, SQLSTATE 23505.
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status")
VALUES (50, 30, 10, 20, 'PO-TEST-PK', '2026-10-12', 1, 'open');

-- 14. purchase unique. Expected: uq_purchase_order_0, SQLSTATE 23505.
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status")
VALUES (1009, 30, 10, 20, 'PO-2026-001', '2026-10-12', 1, 'open');

-- 15. purchase fk supplier. Expected: fk_purchase_order_0, SQLSTATE 23503.
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status")
VALUES (1010, 9003, 10, 20, 'PO-TEST-FK-S', '2026-10-12', 1, 'open');

-- 16. purchase fk warehouse. Expected: fk_purchase_order_1, SQLSTATE 23503.
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status")
VALUES (1011, 30, 9004, 20, 'PO-TEST-FK-W', '2026-10-12', 1, 'open');

-- 17. purchase fk item. Expected: fk_purchase_order_2, SQLSTATE 23503.
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status")
VALUES (1012, 30, 10, 9005, 'PO-TEST-FK-I', '2026-10-12', 1, 'open');

-- 18. purchase check. Expected: purchase_order_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status")
VALUES (1013, 30, 10, 20, 'PO-TEST-CHECK', '2026-10-12', 0, 'open');

-- 19. stock pk. Expected: pk_stock_event, SQLSTATE 23505.
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date")
VALUES (60, 20, 10, NULL, NULL, 'adjustment', 1, '2026-10-12');

-- 20. stock fk item. Expected: fk_stock_event_0, SQLSTATE 23503.
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date")
VALUES (1014, 9006, 10, NULL, 50, 'receipt', 1, '2026-10-12');

-- 21. stock fk warehouse. Expected: fk_stock_event_1, SQLSTATE 23503.
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date")
VALUES (1015, 20, 9007, NULL, 50, 'receipt', 1, '2026-10-12');

-- 22. stock fk source warehouse. Expected: fk_stock_event_2, SQLSTATE 23503.
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date")
VALUES (1016, 20, 11, 9008, NULL, 'transfer', 1, '2026-10-12');

-- 23. stock fk purchase order. Expected: fk_stock_event_3, SQLSTATE 23503.
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date")
VALUES (1017, 20, 10, NULL, 9009, 'receipt', 1, '2026-10-12');

-- 24. stock check. Expected: stock_event_valid, SQLSTATE 23514.
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date")
VALUES (1018, 20, 10, NULL, NULL, 'transfer', 1, '2026-10-12');
