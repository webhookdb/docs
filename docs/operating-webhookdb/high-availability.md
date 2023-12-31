---
title: High Availability
layout: home
parent: Operating WebhookDB
nav_order: 60
---

# High Availability

{: .self-hosting }
This article only applies to [self-hosting]({% link docs/operating-webhookdb/self-hosting.md %}) WebhookDB.
When using [WebookDB Cloud](https://webhookdb.com), this is all handled for you.
But feel free to read on to see how WebhookDB works under the hood.

WebhookDB can be configured for high availability, such as if the primary Postgres or Redis are unavailable.

This is important because while some 3rd party APIs do a good job delivering webhooks reliably, many do not.
Being down for maintenance or a misconfiguration for even a few minutes can result in missing changes from an API,
meaning you'll need other strategies to reconcile.

## Rejected webhooks

WebhookDB performs API-specific verification of the webhooks it receives. If the webhook signing secret changes,
and WebhookDB starts rejecting webhooks, that can cause an issue. Fortunately, WebhookDB preserves the rejected webhooks
so they can be replayed. See [`webhookdb integration replay`]({% link _manual/integration.md %}) for more information.

## Data server availability

If you are using an API with questionable delivery behavior (or even if not),
or see a lot of database disruptions in your own infrastructure,
you can easily run with extra WebhookDB availability for peace of mind.

If there is an error communicating with the primary Postgres or Redis,
WebhookDB can store the failed webhooks in another Postgres database. Once the outage is resolved,
the failed webhooks are replayed automatically and idempotently, as if nothing was ever wrong.

To enable this behavior, use the following two env vars:

- `LOGGED_WEBHOOKS_RESILIENT_DATABASE_URLS`: Space-separated urls for fallback databases.
- `LOGGED_WEBHOOKS_RESILIENT_DATABASE_ENV_VARS`: Space-separated envrionment variable names
  to pull URLs from. If the URL is not static (such as from a Heroku Postgres add-on),
  you can set these instead.
  For example, `LOGGED_WEBHOOKS_RESILIENT_DATABASE_ENV_VARS=HEROKU_POSTGRESQL_BLACK_URL`
  would use the URL string from the `HEROKU_POSTGRESQL_BLACK_URL` env var for logged webhooks.

Note the following about these fallback databases:

- They are used in order, falling back to later ones if earlier ones are not available
  (urls are before those from env vars). Please file an issue if you need random sampling instead.
- They can usually be very small. They need to support a write throughput equal to about your
  number of incoming webhook requests (one write per incoming webhook). Concurrent connections can be low,
  since the connection is established only for the life of the request
  (this introduces some additional load, of course).
- Any database adapter supported by the Sequel gem can be used.
  See [Sequel's docs](http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html)
  for more information.

{% include prevnext.html prev="docs/operating-webhookdb/run-locally.md" next="docs/operating-webhookdb/autoscaling.md" %}
