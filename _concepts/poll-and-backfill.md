---
title: Poll and Backfill
layout: home
nav_order: 30
---

# Poll and Backfill

WebhookDB, despite the name, also works with APIs that do not support webhooks.
It also handles automatically backfilling data webhooks will no longer be sent for.

It does this through an automatic polling and incremental backfilling system.

## Polling

WebhookDB will periodically poll any API that does not support webhooks (which is most of them).
This will happen automatically. The frequency is configured with an environment variable,
like `SPONSY_CRON_EXPRESSION`. This can be set as frequent as you want when self-hosting WebhookDB.

## Backfilling

You can also ask WebhookDB to backfill your data on-demand. This is very useful when setting up an integration,
if you know data was missed, or if you want to define your own polling schedule somewhere else.

You can use the CLI to ask WebhookDB to perform a backfill:

```shell
$ webhookdb backfill stripe_customer_v1
```

Or you can use the API:

```shell
$ curl -X POST https://api.webhookdb.com/v1/organizations/my_org_key/service_integrations/my_integration_id/backfill/job
{"id":"bfj_123","status":"enqueued"}
$ curl https://api.webhookdb.com/v1/organizations/my_org_key/service_integrations/my_integration_id/backfill/job/bfj_123
{"id":"bfj_123","status":"in_progress"}
$ curl https://api.webhookdb.com/v1/organizations/my_org_key/service_integrations/my_integration_id/backfill/job/bfj_123
{"id":"bfj_123","status":"finished"}
```

See [using the API to backfill]({% link docs/api/backfill.md %}) for more details about using the API to backfill.

For a list of flags for the `webhookdb backfill` command, pass `--help` or read the [manual]({% link _manual/backfill.md %}).
