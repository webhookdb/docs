---
title: Integrating WebhookDB
layout: home
nav_order: 300
has_children: true
---

# Integrating WebhookDB

WebhookDB supports three approaches to integrating with external applications.
Each improve on standard paradigms which eliminate complexity on the application developer side. (That's you!)

- Replicate the schematized and normalized data to another database, like Snowflake, DynamoDB, or another Postgres instance.
  We call this [DB Sync]({% link docs/integrating/dbsync.md %}).
- Replicate row changes synchronously to an HTTP endpoint. Think of this like DB replication via triggers
  or Write-Ahead-Logging, except designed for application integration. We call this [HTTP Sync]({% link docs/integrating/httpsync.md %}).
- Use [Notifications]({% link docs/integrating/notifications.md %}) to send updates to another service.
  This is similar to HTTP Sync but requests are made asynchronously, like normal webhooks.
  Importantly, this works even for integrations that do not themselves support webhooks
  (ie they are *backfill-only*).
