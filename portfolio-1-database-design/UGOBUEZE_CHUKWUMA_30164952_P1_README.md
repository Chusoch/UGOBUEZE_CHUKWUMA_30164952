# Portfolio 1 — Database Design and Modelling

I organised the data into warehouse, item, supplier, inventory_balance, purchase_order, stock_event. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| warehouse | 2 |
| item | 2 |
| supplier | 1 |
| inventory_balance | 2 |
| purchase_order | 1 |
| stock_event | 2 |

The 24 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](UGOBUEZE_CHUKWUMA_30164952_P1_Design.md)
- [ER diagram](UGOBUEZE_CHUKWUMA_30164952_P1_ERDiagram.md)
- [Normalisation](UGOBUEZE_CHUKWUMA_30164952_P1_Normalisation.md)
- [Schema](UGOBUEZE_CHUKWUMA_30164952_P1_Schema.sql)
- [Sample data](UGOBUEZE_CHUKWUMA_30164952_P1_SampleData.sql)
- [Constraint tests](UGOBUEZE_CHUKWUMA_30164952_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/UGOBUEZE_CHUKWUMA_30164952_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

