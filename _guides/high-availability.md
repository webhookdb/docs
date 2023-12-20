---
title: High Availability
layout: home
---

# High Availability

While some 3rd party APIs do a good job delivering webhooks reliably, many do not.
Being down for maintenance for even a few minutes can result in missing changes from an API,
meaning you'll need other strategies to reconcile.

As long as those APIs can reach WebhookDB (ie, your load balancer and the WebhookDB service itself are up),
WebhookDB will not lose data. It does this in the following ways:

- Webhooks are logged so they can be replayed if, for example, webhook verification fails.
- Webhooks are logged, first, WebhookDB's Postgres application database.
- If that fails, they are recorded in any other configured Postgres database, until they are handled properly (logged in the Postgres application database and processed by a worker) and deleted from the fallback Postgres.
- If no Postgres database is available, the webhooks are stored in an available Redis database, until it is handled properly and deleted from Redis. 

For more information, see the `Webhookdb::LoggedWebhook` class and the `LOGGEDWEBHOOK_DATABASE_URLS` and `LOGGED_WEBHOOK_REDIS_URLS` environment variables.

#TODO
