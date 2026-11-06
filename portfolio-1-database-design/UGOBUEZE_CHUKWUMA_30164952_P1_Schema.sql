-- Inventory and Supply Chain Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."warehouse" (
  "warehouse_id" bigint NOT NULL,
  "code" text NOT NULL,
  "name" text NOT NULL,
  "location" text NOT NULL,
  CONSTRAINT "pk_warehouse" PRIMARY KEY ("warehouse_id"),
  CONSTRAINT "uq_warehouse_0" UNIQUE ("code")
);
CREATE TABLE portfolio."item" (
  "item_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "name" text NOT NULL,
  "unit" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_item" PRIMARY KEY ("item_id"),
  CONSTRAINT "uq_item_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."supplier" (
  "supplier_id" bigint NOT NULL,
  "supplier_code" text NOT NULL,
  "name" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_supplier" PRIMARY KEY ("supplier_id"),
  CONSTRAINT "uq_supplier_0" UNIQUE ("supplier_code")
);
CREATE TABLE portfolio."inventory_balance" (
  "inventory_balance_id" bigint NOT NULL,
  "warehouse_id" bigint NOT NULL,
  "item_id" bigint NOT NULL,
  "on_hand" bigint NOT NULL,
  "reorder_point" bigint NOT NULL,
  "updated_at" timestamptz NOT NULL,
  CONSTRAINT "pk_inventory_balance" PRIMARY KEY ("inventory_balance_id"),
  CONSTRAINT "uq_inventory_balance_0" UNIQUE ("warehouse_id", "item_id")
);
CREATE TABLE portfolio."purchase_order" (
  "purchase_order_id" bigint NOT NULL,
  "supplier_id" bigint NOT NULL,
  "warehouse_id" bigint NOT NULL,
  "item_id" bigint NOT NULL,
  "order_number" text NOT NULL,
  "ordered_on" date NOT NULL,
  "quantity" bigint NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_purchase_order" PRIMARY KEY ("purchase_order_id"),
  CONSTRAINT "uq_purchase_order_0" UNIQUE ("order_number")
);
CREATE TABLE portfolio."stock_event" (
  "stock_event_id" bigint NOT NULL,
  "item_id" bigint NOT NULL,
  "warehouse_id" bigint NOT NULL,
  "source_warehouse_id" bigint,
  "purchase_order_id" bigint,
  "event_type" text NOT NULL,
  "quantity" bigint NOT NULL,
  "event_date" date NOT NULL,
  CONSTRAINT "pk_stock_event" PRIMARY KEY ("stock_event_id")
);
ALTER TABLE portfolio."inventory_balance" ADD CONSTRAINT "fk_inventory_balance_0" FOREIGN KEY ("warehouse_id") REFERENCES portfolio."warehouse" ("warehouse_id");
ALTER TABLE portfolio."inventory_balance" ADD CONSTRAINT "fk_inventory_balance_1" FOREIGN KEY ("item_id") REFERENCES portfolio."item" ("item_id");
ALTER TABLE portfolio."purchase_order" ADD CONSTRAINT "fk_purchase_order_0" FOREIGN KEY ("supplier_id") REFERENCES portfolio."supplier" ("supplier_id");
ALTER TABLE portfolio."purchase_order" ADD CONSTRAINT "fk_purchase_order_1" FOREIGN KEY ("warehouse_id") REFERENCES portfolio."warehouse" ("warehouse_id");
ALTER TABLE portfolio."purchase_order" ADD CONSTRAINT "fk_purchase_order_2" FOREIGN KEY ("item_id") REFERENCES portfolio."item" ("item_id");
ALTER TABLE portfolio."stock_event" ADD CONSTRAINT "fk_stock_event_0" FOREIGN KEY ("item_id") REFERENCES portfolio."item" ("item_id");
ALTER TABLE portfolio."stock_event" ADD CONSTRAINT "fk_stock_event_1" FOREIGN KEY ("warehouse_id") REFERENCES portfolio."warehouse" ("warehouse_id");
ALTER TABLE portfolio."stock_event" ADD CONSTRAINT "fk_stock_event_2" FOREIGN KEY ("source_warehouse_id") REFERENCES portfolio."warehouse" ("warehouse_id");
ALTER TABLE portfolio."stock_event" ADD CONSTRAINT "fk_stock_event_3" FOREIGN KEY ("purchase_order_id") REFERENCES portfolio."purchase_order" ("purchase_order_id");
ALTER TABLE portfolio."inventory_balance" ADD CONSTRAINT "inventory_balance_nonnegative" CHECK (("on_hand" >= 0) AND ("reorder_point" >= 0));
ALTER TABLE portfolio."purchase_order" ADD CONSTRAINT "purchase_order_quantity_positive" CHECK ("quantity" > 0);
ALTER TABLE portfolio."stock_event" ADD CONSTRAINT "stock_event_valid" CHECK (("quantity" > 0) AND ((("event_type" = 'receipt') AND ("source_warehouse_id" IS NULL)) OR (("event_type" = 'adjustment') AND ("source_warehouse_id" IS NULL)) OR (("event_type" = 'transfer') AND ("source_warehouse_id" IS NOT NULL) AND (("source_warehouse_id" > "warehouse_id") OR ("warehouse_id" > "source_warehouse_id")))));
COMMIT;
