---
title: High Availability
layout: home
parent: Operating WebhookDB
nav_order: 60
---

# High Availability

WebhookDB can be configured for high availability, such as if the primary Postgres or Redis are unavailable.

This is important because while some 3rd party APIs do a good job delivering webhooks reliably, many do not.
Being down for maintenance or a misconfiguration for even a few minutes can result in missing changes from an API,
meaning you'll need other strategies to reconcile.

## Rejected webhooks

WebhookDB performs API-specific verification of the webhooks it receives. If the webhook signing secret changes,
and WebhookDB starts rejecting webhooks, that can cause an issue. Fortunately, WebhookDB preserves the rejected webhooks
so they can be replayed. See [`webhookdb integration replay`]({% link _manual/integration.md %}) for more information.

## Data server availability

If there is an error communicating with the primary Postgres or Redis,
WebhookDB can store the failed webhooks in another Postgres database. Once the outage is resolved,
the failed webhooks are replayed automatically and idempotently, as if nothing was ever wrong.

To enable this behavior, set the `HA_POSTGRES_URLS` environment variable to a space or comma separated list of fallbacks.
As long as a fallback is available, handling the webhook will not error. If you are using an API with questionable delivery behavior,
you may want to keep a small Postgres instance in `HA_POSTGRES_URLS` for peace of mind.

#TODO

{% include prevnext.html prev="docs/operating-webhookdb/run-locally.md" %}