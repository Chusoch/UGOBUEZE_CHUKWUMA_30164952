-- Fictional sample records for Inventory and Supply Chain Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."warehouse" ("warehouse_id", "code", "name", "location") VALUES (10, 'WH-A', 'North Warehouse', 'North District');
INSERT INTO portfolio."warehouse" ("warehouse_id", "code", "name", "location") VALUES (11, 'WH-B', 'South Warehouse', 'South District');
INSERT INTO portfolio."item" ("item_id", "sku", "name", "unit", "active") VALUES (20, 'SKU-A', 'Widget', 'each', TRUE);
INSERT INTO portfolio."item" ("item_id", "sku", "name", "unit", "active") VALUES (21, 'SKU-B', 'Gadget', 'box', TRUE);
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_code", "name", "active") VALUES (30, 'SUP-A', 'Acme Supply', TRUE);
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at") VALUES (40, 10, 20, 25, 5, '2026-10-01T10:00:00Z');
INSERT INTO portfolio."inventory_balance" ("inventory_balance_id", "warehouse_id", "item_id", "on_hand", "reorder_point", "updated_at") VALUES (41, 11, 21, 8, 3, '2026-10-02T11:30:00+00:00');
INSERT INTO portfolio."purchase_order" ("purchase_order_id", "supplier_id", "warehouse_id", "item_id", "order_number", "ordered_on", "quantity", "status") VALUES (50, 30, 10, 20, 'PO-2026-001', '2026-10-03', 12, 'open');
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date") VALUES (60, 20, 10, NULL, 50, 'receipt', 12, '2026-10-10');
INSERT INTO portfolio."stock_event" ("stock_event_id", "item_id", "warehouse_id", "source_warehouse_id", "purchase_order_id", "event_type", "quantity", "event_date") VALUES (61, 21, 11, 10, NULL, 'transfer', 2, '2026-10-11');
COMMIT;
