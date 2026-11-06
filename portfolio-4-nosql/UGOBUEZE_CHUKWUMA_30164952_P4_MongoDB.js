// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("inventory_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("inventory_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "receipt",
                    "transfer"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "stock_event"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "stock_event_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("inventory_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "carrier": "illustrative carrier",
                "tracking_code": "illustrative tracking_code",
                "transfer_reference": "illustrative transfer_reference",
                "adjustment_reason": "illustrative adjustment_reason"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "receipt",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "stock_event",
            "key": {
                "stock_event_id": 61
            },
            "snapshot": {
                "stock_event_id": 61,
                "item_id": 21,
                "warehouse_id": 11,
                "source_warehouse_id": 10,
                "purchase_order_id": null,
                "event_type": "transfer",
                "quantity": 2,
                "event_date": "2026-10-11"
            }
        },
        "embedded": {
            "item": [
                {
                    "key": {
                        "item_id": 21
                    },
                    "snapshot": {
                        "item_id": 21,
                        "sku": "SKU-B",
                        "name": "Gadget",
                        "unit": "box",
                        "active": true
                    },
                    "via": [
                        "stock_event.item_id → item"
                    ]
                }
            ],
            "warehouse": [
                {
                    "key": {
                        "warehouse_id": 11
                    },
                    "snapshot": {
                        "warehouse_id": 11,
                        "code": "WH-B",
                        "name": "South Warehouse",
                        "location": "South District"
                    },
                    "via": [
                        "stock_event.warehouse_id → warehouse"
                    ]
                },
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
                        "stock_event.source_warehouse_id → warehouse"
                    ]
                }
            ],
            "purchase_order": []
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "transfer",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "stock_event",
            "key": {
                "stock_event_id": 61
            },
            "snapshot": {
                "stock_event_id": 61,
                "item_id": 21,
                "warehouse_id": 11,
                "source_warehouse_id": 10,
                "purchase_order_id": null,
                "event_type": "transfer",
                "quantity": 2,
                "event_date": "2026-10-11"
            }
        },
        "embedded": {
            "item": [
                {
                    "key": {
                        "item_id": 21
                    },
                    "snapshot": {
                        "item_id": 21,
                        "sku": "SKU-B",
                        "name": "Gadget",
                        "unit": "box",
                        "active": true
                    },
                    "via": [
                        "stock_event.item_id → item"
                    ]
                }
            ],
            "warehouse": [
                {
                    "key": {
                        "warehouse_id": 11
                    },
                    "snapshot": {
                        "warehouse_id": 11,
                        "code": "WH-B",
                        "name": "South Warehouse",
                        "location": "South District"
                    },
                    "via": [
                        "stock_event.warehouse_id → warehouse"
                    ]
                },
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
                        "stock_event.source_warehouse_id → warehouse"
                    ]
                }
            ],
            "purchase_order": []
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "carrier": "illustrative carrier",
                "tracking_code": "illustrative tracking_code",
                "transfer_reference": "illustrative transfer_reference",
                "adjustment_reason": "illustrative adjustment_reason"
            }
        }
    }
]));
  await db.getCollection("inventory_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("inventory_events").find({"eventType":"receipt"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("inventory_events").find({"source.key.stock_event_id":60}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("inventory_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("inventory_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("inventory_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("inventory_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("inventory_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
