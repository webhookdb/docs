---
title: Hosted with WebhookDB Cloud
layout: home
parent: Operating WebhookDB
nav_order: 10
---

# WebhookDB Cloud

When using [WebhookDB Cloud](https://webhookdb.com),
you don't have to operate anything yourself.
You configure your integrations using our CLI,
get a database connection string to access your data,
and otherwise everything is just done for you.

- Webhooks are sent to our servers.
- Any API keys you provide are stored in our application database.
- The data we store on your behalf sits on one of our shared database servers.
- We maintain the database users and hosts (you only have read-only access).

See more information at [webhookdb.com](https://webhookdb.com).

## WebhookDB Cloud FAQ

### How is my data stored?

All of your data is stored encrypted in databases in Amazon Web Services.

The data for WebhookDB itself (customers, organizations, etc.) is stored in one database (the "application database").

The replicated API data for each organization is stored in a separate database ("replication databases").

All reads and writes to your organization's replicated data are done through extremely narrow Postgres roles.
The connection string for a replication database can only operate on that database.

Connection strings are stored in the WebhookDB 'app' table. Connection strings,
and all sensitive data, are encrypted at the column level with a regularly rotated key.
That is, even if someone exfiltrated a copy of the application database,
they would not be able to access the connection strings to any replication database.

If your connection strings ever become compromised,
you can rotate them from the CLI with `webhookdb db roll-credentials`.

### I though we should never expose a database?

This advice is generally true, but WebhookDB has two things going for it.

First, managing user access is a core concern, similar to something like shared database hosting
(before the widespread adoption of Kubernetes, many database hosts put many shared databases on one server).

There's nothing conceptually wrong with exposing your database to the public;
it's just that the failure mode can be catastrophic so you should avoid it
unless you know what you're doing.

Second, if you still don't feel good about it,
you can [self-host WebhookDB]({% link docs/operating-webhookdb/self-hosting.md %}) so it sits in your VPC.
That way, nothing outside of your backend can access your replicated data.
You can then implement your own endpoint,
using your access control, to access WebhookDB.

{% include prevnext.html prev="docs/operating-webhookdb/index.md" next="docs/operating-webhookdb/byodb.md" %}
