---
title: WebhookDB
layout: home
nav_order: 100
---

# WebhookDB Documentation

## What is WebhookDB?

WebhookDB is a database platform engineered to make integration of 3rd and 1st party APIs simpler, faster, more reliable and more secure.

Instead of making calls to external services, WebhookDB automatically and immediately syncs data to a database you can query.
Because the data is resident in your own database (or on a hosted plan via [WebhookDB Cloud](https://webhookdb.com)),
working with APIs becomes as fast and reliable as working with your own data.

[Learn more]({% link _guides/getting-started.md %}){: .btn .btn-blue }

## Popular Features 🔥

### [Schemas and normalization →]({% link _guides/schematization.md %})

All data replicated via WebhookDB is schematized and normalized.
You no longer have to worry about parsing and converting timestamps and dates,
parsing embedded JSON fragments, or dealing with out-of-order webhooks.
WebhookDB does this all for you, and you just query the database or receive replicated data.

### [HTTP replication →]({% link _guides/httpsync.md %})

HTTP replication can call custom endpoints with configurable batches of new and updated rows.
This is useful when you are transforming 3rd party API data into your own database models,
and you want to know about changes immediately.
HTTP replication sounds like webhooks, but are easier to reason about, like database triggers.

### [Resilient and available →]({% link _guides/high-availability.md %})

WebhookDB uses several strategies to ensure that, even if its own data stores are down, received webhooks are never lost.
This eliminates a significant reliability challenge when integrating with arbitrary 3rd party APIs.
