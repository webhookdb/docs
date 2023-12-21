---
title: Operating WebhookDB
layout: home
nav_order: 350
has_children: true
---

# Operating WebhookDB

WebhookDB is built to be simple to operate, with a minimum of moving parts and operating costs and complexity.
At its core, it takes the form of a standard application with web processes, worker processes,
a database for application data (Postgres), and a database for jobs (Redis).

{: .notice }
Future versions of WebhookDB may eliminate the Redis dependency.

Most deployments of WebhookDB can be fully served with this setup, scaling resources as needed.

There are three primary ways to host and use WebhookDB: WebhookDB Cloud, bring-your-own-database, and self-hosting.
When you are self-hosting, there are some operational knobs and customizations to be aware of as well.