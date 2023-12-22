---
title: Replication Databases
layout: home
nav_order: 60
---

# Replication Databases

API data can be replicated into different databases,
not just Postgres. The only requirement is that the database
has support for conditional upserts.

This means even NoSQL databases like DynamoDB can be replicated into.

WebhookDB has beta support for replicating into other databases
in the [Enterprise Edition]({% link docs/enterprise.md %}).
As all the rough edges are worked out,
additional database support will be upstreamed into the
open source version.

Note that most analytics databases like Snowflake and Redshift
are not a good choice for replication, since WebhookDB often has to
do many inserts rather than bulk updates.
Instead, you can use Postgres (or another supported replication database),
and use [DB Sync]({% link docs/integrating/dbsync.md %}) to get your data
into your analytics systems.

If there is a database you want supported, feel free to file an issue or pull request.
