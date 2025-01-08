---
title: Error Handlers
layout: home
parent: Integrating WebhookDB
nav_order: 50
---

# Error handlers

Sometimes replication will fail because of issues with the replicator setup.
This could be because credentials have become invalid,
a URL no longer exists, etc.

In these cases, WebhookDB needs to notify the organization about the failure.

By default, organization admins are emailed with information about the error.
The emails are rate limited, so you won't get more than a dozen or so a day.

Alternatively, organization admins can set up _error handlers_,
which are called with a structured payload for every error that occurs.
This allows your application to respond to the exception with custom logic,
or track it in an error handling tool.

To create an error handler, run:

    $ webhookdb error-handler create

Then paste in the URL.

If the URL is a Sentry DSN, WebhookDB will send messages directly to Sentry.

Otherwise, WebhookDB will POST to the URL, as explained below.

## Sentry URLS (DSNs)

If the error handler URL is Sentry DSN (like `https://sentrypublickey@1234.ingest.sentry.io/123`),
WebhookDB will send messages to it.

Sentry DSN's are assumed to be hosted at `sentry.io`.

If the URL is the DSN for a self-hosted sentry, you can use a protocol of `sentry`.
For example, for a Sentry DSN of `http://pubkey@sentry.webhookdb.com:9999/123`,
you can use the DSN `sentry://pubkey@sentry.webhookdb.com:9999/123` instead.

## Other URLs

For other URLs, like `https://api.yourbackend.com/webhookdb/error_handler`,
WebhookDB will POST with a request like the following:

```
$ curl -d '{
  "details": {},
  "error_type": "",
  "message": "",
  "organization_key": "",
  "service_integration_name": "",
  "service_integration_table": "",
  "signature": ""
}' \
    -H 'Content-Type: application/json' \
    https://api.yourbackend.com/webhookdb/error_handler
```

The values in the `details` key change depending on the `error_type`,
but should include enough structured information for diagnostic and programming purposes.

## Future changes

Please file an issue if you need any of the following:

- Alternative error handling services instead of Sentry
- Authentication/authorization of error handling endpoints.

{% include prevnext.html prev="docs/integrating/notifications.md" next="docs/integrating/saved-queries.md" %}
