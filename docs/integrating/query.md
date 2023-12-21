---
title: Query Access
layout: home
parent: Integrating WebhookDB
nav_order: 5
---

There are a few ways to query replicated data in WebhookDB.

Note that we have [a repository](https://github.com/webhookdb/webhookdb-demos) with some example patterns for querying WebhookDB.

## Use the connection string directly

This is a great option for integrating with analytics systems,
or where you can make independent queries against WebhookDB.
For example, you do not need to `JOIN` or use subselects between the WebhookDB database and your own.

It's also a good option if you aren't using Postgres otherwise;
you can use a Postgres driver to connect to WebhookDB, no matter what your app is using.

```ruby
DB = Sequel.connect(ENV['DATABASE_URL'])
WHDB_DB = Sequel.connect(ENV['WHDB_DATABASE_URL'])
user = DB[:users][id: user_id]
charges_for_user = WHDB_DB[:stripe_charge_v1_abc0].where(customer_id: user[:stripe_customer_id]).all
```

## Write into your own database

WebhookDB writes into your database, so you can use the same connection as your application.

The best integration option if you have a tight coupling between your application
and the data in WebhookDB.

```ruby
DB = Sequel.connect(ENV['DATABASE_URL'])
charges_for_user = DB[:webhookdb][:stripe_charge_v1_abc0].join(DB[:users], customer_id: :stripe_customer_id).where(id: user_id)
```

## Use the CLI

You can use the WebhookDB CLI to run SQL queries.
This is generally only useful where you cannot connect to the database otherwise (like drivers are unavailable
or the port is closed) or for testing purposes.

```
$ webhookdb db sql "SELECT * FROM stripe_charge_v1_abc0 WHERE customer_id='cus_123'"
```

## Use the API

Very useful in environments where drivers may not be availble.
One common example is using WebhookDB from Wordpress.
You can query your replicated data via the API, rather than worrying about installing a driver.

See [Querying via the API]({% link _guides/api/query.md %}) for more info.

```
$ curl -X POST -d '{"query":"SELECT * FROM stripe_charge_v1_abc0}' -H "Content-Type: application/json" https://api.webhookdb.com/v1/db/my_org/sql
```

## Import the WebhookDB database as a Foreign Data Wrapper (FDW)

Postgres Foreign Data Wrappers are an amazing piece of technology
that allows you to use SQL to query external databases,
including other types of database servers or another Postgres server.

FDWs allow you to use the WebhookDB database within another Postgres database,
including for things like `JOIN` and subselects.

You can combine the FDW with a *materialized view* in your own database
if you need faster speed or better availability.

Please refer to our [FDW integration example](https://github.com/lithictech/webhookdb-demos/tree/main/app-fdw-rb)
for more details about setting up the foreign server, and optionally, a materialized view.

{% include prevnext.html prev="docs/integrating/index.md" next="docs/integrating/dbsync.md" %}

#TODO
