# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection inventory_events for receipt and transfer events. These are fictional event examples based on stock_event, purchase_order, item, warehouse.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related item, warehouse, purchase_order details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "receipt",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "stock_event",
        "key": {
            "stock_event_id": 60
        },
        "snapshot": {
            "stock_event_id": 60,
            "item_id": 20,
            "warehouse_id": 10,
            "source_warehouse_id": null,
            "purchase_order_id": 50,
            "event_type": "receipt",
            "quantity": 12,
            "event_date": "2026-10-10"
        }
    },
    "embedded": {
        "item": [
            {
                "key": {
                    "item_id": 20
                },
                "snapshot": {
                    "item_id": 20,
                    "sku": "SKU-A",
                    "name": "Widget",
                    "unit": "each",
                    "active": true
                },
                "via": [
                    "stock_event.item_id → item",
                    "stock_event.purchase_order_id → purchase_order.item_id → item"
                ]
            }
        ],
        "warehouse": [
            {
                "key": {
                    "warehouse_id": 10
                },
                "snapshot": {
                    "warehouse_id": 10,
                    "code": "WH-A",
                    "name": "North Warehouse",
                    "location": "North District"
                },
                "via": [
                    "stock_event.warehouse_id → warehouse",
                    "stock_event.purchase_order_id → purchase_order.warehouse_id → warehouse"
                ]
            }
        ],
        "purchase_order": [
            {
                "key": {
                    "purchase_order_id": 50
                },
                "snapshot": {
                    "purchase_order_id": 50,
                    "supplier_id": 30,
                    "warehouse_id": 10,
                    "item_id": 20,
                    "order_number": "PO-2026-001",
                    "ordered_on": "2026-10-03",
                    "quantity": 12,
                    "status": "open"
                },
                "via": [
                    "stock_event.purchase_order_id → purchase_order"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("inventory_events").find({"eventType":"receipt"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "receipt",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "stock_event_id": 60
    }
  },
  {
    "_id": "event_000003",
    "eventType": "receipt",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "stock_event_id": 61
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("inventory_events").find({"source.key.stock_event_id":60}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "receipt",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "stock_event_id": 60
    }
  },
  {
    "_id": "event_000002",
    "eventType": "transfer",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "stock_event_id": 60
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "receipt",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "stock_event_id": 60
    }
  },
  {
    "_id": "event_000002",
    "eventType": "transfer",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "stock_event_id": 60
    }
  },
  {
    "_id": "event_000003",
    "eventType": "receipt",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "stock_event_id": 61
    }
  },
  {
    "_id": "event_000004",
    "eventType": "transfer",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "stock_event_id": 61
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| receipt | 2 |
| transfer | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run UGOBUEZE_CHUKWUMA_30164952_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/UGOBUEZE_CHUKWUMA_30164952_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

