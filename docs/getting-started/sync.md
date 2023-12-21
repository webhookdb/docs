---
title: Sync to a database or HTTP endpoint 
layout: home
parent: Getting started
nav_order: 70
---

# Sync to a database or endpoint

For many applications, being able to query data via SQL is nice, but not sufficient. You also need to know when data changes.

WebhookDB supports three approaches to integrating with external applications.
Each improve on standard paradigms which eliminate complexity on the application developer side. (That's you!)

- Replicate row changes synchronously to an HTTP endpoint. Think of this like DB replication via triggers
  or Write-Ahead-Logging, except designed for application integration. We call this [HTTP Sync]({% link docs/integrating/httpsync.md %}).
- Replicate the schematized and normalized data to another database, like Snowflake, DynamoDB, or another Postgres instance.
  We call this [DB Sync]({% link docs/integrating/dbsync.md %}).
- Use [Notifications]({% link docs/integrating/notifications.md %}) to send updates to another service.
  This is similar to HTTP Sync but requests are made asynchronously, like normal webhooks.
  Importantly, this works even for integrations that do not themselves support webhooks
  (ie they are *backfill-only*).

This is outside of the scope of this tutorial, but it's too useful not to mention here!

{% include prevnext.html prev="docs/getting-started/backfill.md" next="docs/getting-started/unit-tests.md" %}
