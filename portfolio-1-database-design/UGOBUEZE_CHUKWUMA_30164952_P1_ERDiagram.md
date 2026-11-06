# Inventory and Supply Chain Management System — ER diagram

```mermaid
erDiagram
    direction LR
    warehouse {
        bigint warehouse_id PK
        text code UK
        text name
        text location
    }
    item {
        bigint item_id PK
        text sku UK
        text name
        text unit
        boolean active
    }
    supplier {
        bigint supplier_id PK
        text supplier_code UK
        text name
        boolean active
    }
    inventory_balance {
        bigint inventory_balance_id PK
        bigint warehouse_id FK
        bigint item_id FK
        integer on_hand
        integer reorder_point
        timestamptz updated_at
    }
    purchase_order {
        bigint purchase_order_id PK
        bigint supplier_id FK
        bigint warehouse_id FK
        bigint item_id FK
        text order_number UK
        date ordered_on
        integer quantity
        text status
    }
    stock_event {
        bigint stock_event_id PK
        bigint item_id FK
        bigint warehouse_id FK
        bigint source_warehouse_id FK "Optional"
        bigint purchase_order_id FK "Optional"
        text event_type
        integer quantity
        date event_date
    }
    warehouse ||--o{ inventory_balance : "warehouse_id"
    item ||--o{ inventory_balance : "item_id"
    supplier ||--o{ purchase_order : "supplier_id"
    warehouse ||--o{ purchase_order : "warehouse_id"
    item ||--o{ purchase_order : "item_id"
    item ||--o{ stock_event : "item_id"
    warehouse ||--o{ stock_event : "warehouse_id"
    warehouse o|--o{ stock_event : "source_warehouse_id"
    purchase_order o|--o{ stock_event : "purchase_order_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/UGOBUEZE_CHUKWUMA_30164952_ERDiagram.png)
