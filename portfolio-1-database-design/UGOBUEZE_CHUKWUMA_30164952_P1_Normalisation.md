# Inventory and Supply Chain Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| supplier_id | purchase_order records (list) |
| --- | --- |
| 30 | [50] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| purchase_order.purchase_order_id | purchase_order.supplier_id | purchase_order.warehouse_id | purchase_order.item_id | purchase_order.order_number | supplier.supplier_id | supplier.supplier_code | warehouse.warehouse_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 50 | 30 | 10 | 20 | PO-2026-001 | 30 | SUP-A | 10 |

Key: purchase_order_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## purchase_order_example

| purchase_order.purchase_order_id | purchase_order.supplier_id | purchase_order.warehouse_id | purchase_order.item_id | purchase_order.order_number | supplier.supplier_id | supplier.supplier_code | warehouse.warehouse_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 50 | 30 | 10 | 20 | PO-2026-001 | 30 | SUP-A | 10 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## warehouse

| warehouse_id | code | name | location |
| --- | --- | --- | --- |
| 10 | WH-A | North Warehouse | North District |
| 11 | WH-B | South Warehouse | South District |

## item

| item_id | sku | name | unit | active |
| --- | --- | --- | --- | --- |
| 20 | SKU-A | Widget | each | true |
| 21 | SKU-B | Gadget | box | true |

## supplier

| supplier_id | supplier_code | name | active |
| --- | --- | --- | --- |
| 30 | SUP-A | Acme Supply | true |

## inventory_balance

| inventory_balance_id | warehouse_id | item_id | on_hand | reorder_point | updated_at |
| --- | --- | --- | --- | --- | --- |
| 40 | 10 | 20 | 25 | 5 | 2026-10-01T10:00:00+00:00 |
| 41 | 11 | 21 | 8 | 3 | 2026-10-02T11:30:00+00:00 |

## purchase_order

| purchase_order_id | supplier_id | warehouse_id | item_id | order_number | ordered_on | quantity | status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 50 | 30 | 10 | 20 | PO-2026-001 | 2026-10-03 | 12 | open |

## stock_event

| stock_event_id | item_id | warehouse_id | source_warehouse_id | purchase_order_id | event_type | quantity | event_date |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 60 | 20 | 10 | NULL | 50 | receipt | 12 | 2026-10-10 |
| 61 | 21 | 11 | 10 | NULL | transfer | 2 | 2026-10-11 |

## Dependencies

- warehouse: (warehouse_id) → code, name, location
- item: (item_id) → sku, name, unit, active
- supplier: (supplier_id) → supplier_code, name, active
- inventory_balance: (inventory_balance_id) → warehouse_id, item_id, on_hand, reorder_point, updated_at
- purchase_order: (purchase_order_id) → supplier_id, warehouse_id, item_id, order_number, ordered_on, quantity, status
- stock_event: (stock_event_id) → item_id, warehouse_id, source_warehouse_id, purchase_order_id, event_type, quantity, event_date

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
