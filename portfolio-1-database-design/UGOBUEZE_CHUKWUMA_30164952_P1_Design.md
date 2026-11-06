# Inventory and Supply Chain Management System — database design

My case study records warehouse, item, supplier, inventory_balance, purchase_order, stock_event.

## Users

- Inventory staff who review stock levels and record events
- Procurement staff who manage suppliers and purchase orders
- Warehouse managers who review stock by location

## Main operations

- Create a purchase order for one item from a supplier to a warehouse
- Record receipt, transfer, or adjustment events and update current stock
- Find balances below their reorder points and summarize receipts by warehouse and item
- Benchmark the same synthetic event-date filter before and after creating a B-tree index, using 20000 synthetic event rows and recording the query plan and elapsed time for each run

## Entities

| Entity | Information stored |
| --- | --- |
| warehouse | A storage location that receives, holds, or sends inventory. |
| item | A product tracked in warehouse stock and purchase orders. |
| supplier | A vendor that can supply items through purchase orders. |
| inventory_balance | The current on-hand quantity and reorder point for an item at a warehouse. |
| purchase_order | An order for one item from a supplier, delivered to a warehouse. |
| stock_event | A dated receipt, transfer, or adjustment affecting stock at a destination warehouse. |

## warehouse

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| warehouse_id | BIGINT | PK | Yes |
| code | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| location | TEXT |  | Yes |
- Unique key: (code).

## item

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| item_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| unit | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## supplier

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| supplier_id | BIGINT | PK | Yes |
| supplier_code | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (supplier_code).

## inventory_balance

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| inventory_balance_id | BIGINT | PK | Yes |
| warehouse_id | BIGINT | FK | Yes |
| item_id | BIGINT | FK | Yes |
| on_hand | INTEGER |  | Yes |
| reorder_point | INTEGER |  | Yes |
| updated_at | TIMESTAMPTZ |  | Yes |
- warehouse_id → warehouse.warehouse_id
- item_id → item.item_id
- Unique key: (warehouse_id, item_id).

## purchase_order

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| purchase_order_id | BIGINT | PK | Yes |
| supplier_id | BIGINT | FK | Yes |
| warehouse_id | BIGINT | FK | Yes |
| item_id | BIGINT | FK | Yes |
| order_number | TEXT | Unique | Yes |
| ordered_on | DATE |  | Yes |
| quantity | INTEGER |  | Yes |
| status | TEXT |  | Yes |
- supplier_id → supplier.supplier_id
- warehouse_id → warehouse.warehouse_id
- item_id → item.item_id
- Unique key: (order_number).

## stock_event

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| stock_event_id | BIGINT | PK | Yes |
| item_id | BIGINT | FK | Yes |
| warehouse_id | BIGINT | FK | Yes |
| source_warehouse_id | BIGINT | FK | No |
| purchase_order_id | BIGINT | FK | No |
| event_type | TEXT |  | Yes |
| quantity | INTEGER |  | Yes |
| event_date | DATE |  | Yes |
- item_id → item.item_id
- warehouse_id → warehouse.warehouse_id
- source_warehouse_id → warehouse.warehouse_id
- purchase_order_id → purchase_order.purchase_order_id

## Relationships and business rules

- Each warehouse has a required code that is unique across warehouses.
- Each item has a required SKU that is unique across items.
- Each supplier has a required code that is unique across suppliers.
- Only one current inventory balance exists for each warehouse and item pair.
- On-hand quantity and reorder point must each be zero or greater; stock updates lock and recheck the balance row so concurrent changes cannot produce a negative on-hand quantity.
- A purchase order must request a quantity greater than zero.
- Event type is receipt, transfer, or adjustment and quantity is greater than zero; transfers require a source warehouse different from the destination, while other event types have no source warehouse.
- Each inventory balance warehouse_id references warehouse.warehouse_id.
- Each inventory balance item_id references item.item_id.
- Each purchase order supplier_id references supplier.supplier_id.
- Each purchase order warehouse_id references warehouse.warehouse_id.
- Each purchase order item_id references item.item_id.
- Each stock event item_id references item.item_id.
- Each stock event warehouse_id references warehouse.warehouse_id.
- When source_warehouse_id is present on a stock event, it references warehouse.warehouse_id.
- When purchase_order_id is present on a stock event, it references purchase_order.purchase_order_id.

## Assumptions

- Each purchase_order record represents one item; multi-item orders and separate order-line entities are outside this small model.
- A stock_event of type receipt represents a shipment arrival; a stock_event of type transfer records movement between warehouses, so shipment and transfer records are not separate entities.
- inventory_balance stores the current quantity for one item at one warehouse; recorded stock events explain changes to that balance.
- For receipts and adjustments, source_warehouse_id is absent; for transfers, it identifies a warehouse different from the destination.
- All example records and benchmark rows are synthetic; student names and IDs are not part of the specification.

