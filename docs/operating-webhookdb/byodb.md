---
title: Bring-Your-Own-Database
layout: home
parent: Operating WebhookDB
nav_order: 20
---

# Bring Your Own Database (BYODB)

"BYODB" uses [WebhookDB Cloud]({% link docs/operating-webhookdb/cloud-hosted.md %}),
but you provide the database that data is replicated to, rather than using one of our shared database hosts.

- Webhooks are sent to our servers.
- Any API keys you provide are stored in our application database.
- *We write all API data to your database.* We still store some data for our job and retry system,
  but everything else resides in your database. You provide us a connection with
  write access to a particular database or schema.

This is a good option for customers who benefit from the better latency of running their own database,
but do not want to operate WebhookDB themselves.

We do not yet offer self-serve BYODB setup,
since it requires you provision a database user with the right permissions,
and can be tricky to get right.
Please email [hello@webhookdb.com](mailto:hello@webhookdb.com)
if you would like to get set up with BYODB.

In the meantime, you can start on [WebhookDB Cloud]({% link docs/operating-webhookdb/cloud-hosted.md %}
and we can migrate to your database when you're ready (migrations are lossless and zero-downtime).

{% include prevnext.html prev="docs/operating-webhookdb/cloud-hosted.md" next="docs/operating-webhookdb/self-hosting.md" %}
