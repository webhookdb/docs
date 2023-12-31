---
title: Autoscaling
layout: home
parent: Operating WebhookDB
nav_order: 65
---

# Autoscaling

{: .self-hosting }
This article only applies to [self-hosting]({% link docs/operating-webhookdb/self-hosting.md %}) WebhookDB.
When using [WebookDB Cloud](https://webhookdb.com),
this is all handled for you.

Since WebhookDB is naturally very 'bursty', is intended real-time processing of events,
but also promises to be simple and inexpensive to operate, it has out-of-the-box support for autoscaling.

## Web

Web autoscaling is very platform dependent, and most platforms have ways to do it by measuring response time.
These can be used for WebhookDB, as it's generally the simplest solution out-of-the-box.

That said, the handling of webhooks is usually very fast; two web processes can handle a high enough throughput in most cases.

## Workers

Most platforms provide limited or no capability for worker autoscaling,
since there are no standard ways of measuring latency since job systems vary so widely
(compared to something like response time for HTTP requests).

WebhookDB has a general-purpose core autoscaling mechanism,
which has relatively slim provider-specific implementations.

## Configuration

The following environment variables are used to configure autoscaling:

- `AUTOSCALER_ENABLED`: Whether autoscaling is enabled. Default: `false`
- `AUTOSCALER_PROVIDER`: Name of the provider to use for autoscaling (see Providers below).
  Availablel providers: `heroku`
  Default: ''
- `AUTOSCALER_LATENCY_THRESHOLD`: What latency should we alert on? Default: `10` (seconds)
- `AUTOSCALER_ALERT_INTERVAL`: Only alert this often. For example, with poll_interval of 10 seconds
  and alert_interval of 200 seconds, we'd alert once and then 210 seconds later.
  Default: `180` (seconds)
- `AUTOSCALER_POLL_INTERVAL`: How often should Autoscaler check for latency? Default: `30` (seconds)
- `AUTOSCALER_MAX_ADDITIONAL_WORKERS`: How many additional workers should be autoscaled to?
  Not relevant for all providers. Default: `2`
- `AUTOSCALER_LATENCY_RESTORED_THRESHOLD`: After an alert happens, what latency should be considered "back to normal"
  and the 'latency restored handlers' will be called?
  In most cases this should be the same as (and defaults to) `AUTOSCALER_LATENCY_THRESHOLD`
  so that we're 'back to normal' once we're below the threshold.
  It may also commonly be 0, so that the callback is fired when the queue is entirely clear.
  Note that, if `AUTOSCALER_LATENCY_RESTORED_THRESHOLD` is less than `AUTOSCALER_LATENCY_THRESHOLD`,
  while the latency is between the two, no alerts will fire.
  Default: 0
- `AUTOSCALER_HOSTNAME_REGEX`: What hosts/processes should this run on? 
  Looks at `DYNO` env var and `Socket.gethostname` for a match. 
  Default to only run on `web.1`, which is the first web worker in various systems, including Heroku.
  Make sure to run on the web process, not worker process, so we report backed up queues
  in case we, say, turn off all workers (broken web processes  are generally easier to find). 
  Default: `^web\.1$`. Note that this should be a regex, and the string is used verbatim.

## Providers

These can be selected by setting the `AUTOSCALER_PROVIDER` environment variable.

### `AUTOSCALER_PROVIDER=heroku`

Scale dynos up and down based on latency. Uses the Heroku API.

- `WEBHOOKDB_HEROKU_OAUTH_TOKEN`: Set to an [OAuth Token](https://devcenter.heroku.com/articles/oauth#direct-authorization)
  used to communicate with the Heroku PlatformAPI for this WebhookDB Heroku application.
- `WEBHOOKDB_HEROKU_OAUTH_ID`: The ID of the OAuth token. Used to identify the source of the OAuth token.
- `AUTSCALER_MAX_ADDITIONAL_WORKERS`: Maximum number of workers to add to the base amount configured in Heroku.
  The main thing to watch out for here is connection exhaustion to your datastores.
  Default: 2
- `AUTOSCALER_APP_ID_OR_APP_NAME`: Used to make the Heroku API calls. 
  See <https://devcenter.heroku.com/articles/platform-api-reference#formation-info>.
  Default: `ENV.fetch("HEROKU_APP_NAME")`
- `AUTOSCALER_FORMATION_ID_OR_FORMATION_TYPE`: Used to make the Heroku API calls.
  See <https://devcenter.heroku.com/articles/platform-api-reference#formation-update>.
  Default: `worker`.

### Additional providers

Please [file an issue](https://github.com/webhookdb/webhookdb/issues/new) to add support for additional providers.
Sometimes these may not be direct autoscaler implementations; for example, it could be recording a latency metric
in Prometheus, and some other part of your backend, already set up for managing autoscaling, triggers additional containers
to be launched/stopped.

Customer providers just implement a `#scale_up` and `#scale_down` method,
called when the autoscaler determines scale up/down is needed.

{% include prevnext.html prev="docs/operating-webhookdb/high-availability.md" next="docs/operating-webhookdb/securing.md" %}
