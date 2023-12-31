---
title: DB Sync
layout: home
parent: Integrating WebhookDB
nav_order: 10
---

# Sync to a database

WebhookDB can take its nicely schematized and normalized data and send it to any other database.
Usually this means a data warehouse like Snowflake, Redshift, or some other Postgres instance.
Most other database syncing systems update your data only periodically,
but WebhookDB will sync data in near-real-time.

DB Sync is easy to get going. When you run `webhookdb dbsync create <integration id or table>`,
we'll prompt you for the connection string and sync interval.
While [WebhookDB Cloud](https://webhookdb.com) has a lower limit on sync intervals,
you can get real-time DB syncing when self hosting.

By default, we'll replicate to the `public` schema and the same table name as the integration's table,
or you can provide the schema and table name.

```
$ webhookdb integrations list
        NAME               TABLE                      ID
stripe_customer_v1 stripe_customer_v1_8f82 svi_6i8987gxug15z0mxhi0dhwns0

$ webhookdb dbsync create stripe_customer_v1
Enter the database connection string that WebhookDB should sync data to: postgres://user:pass@dburl/db
How many seconds between syncs (60 to 86400): 800
Every 800 seconds, data from stripe_customer_v1 in stripe_customer_v1_8f82 will be synchronized to postgres://***:***@dburl/db
```

You can also provide the schema and table with flags (this will sync to `stripe.customers` in the configured database):

```
$ webhookdb dbsync create stripe_customer_v1 --schema stripe --table customers stripe_customer_v1_8f82
```

Once the DB sync is successfully set up, it will periodically post new information to the endpoint using the interval you provided.
You can also trigger a sync manually using the command `webhookdb dbsync trigger`.

We currently support syncing with Postgres and Snowflake.
Other databases, including DynamoDB, Redshift, BigQuery, MySQL, and SQL Server are available with [WebhookDB Enterprise]({% link docs/enterprise.md %}).

For more information on working with DB Syncing, you can check out the [`dbsync` manual page]({% link _manual/dbsync.md %}).

{% include prevnext.html prev="docs/integrating/query.md" next="docs/integrating/httpsync.md" %}
