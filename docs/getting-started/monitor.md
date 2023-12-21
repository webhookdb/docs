---
title: Monitor your deliveries 
layout: home
parent: Getting started
nav_order: 80
---

# Monitor your deliveries

You can monitor whether your integration's endpoint is successfully receiving webhooks.
For example, maybe the webhook secret used to sign payloads was changed,
and deliveries are now failing.

You can view the recent delivery history:

```
webhookdb integrations stats svi_n5ix69j1on4g4y32z7vlfq1n

           NAME               VALUE   
Count Last 7 Days                  458
Successful Last 7 Days             458
Successful Last 7 Days (Percent) 100.0%
Rejected Last 7 Days                  0
Rejected Last 7 Days (Percent)      0.0%
Successful Of Last 10 Webhooks       10
Rejected Of Last 10 Webhooks          0
```

In the future, you will be able to automatically monitor and alert on failed webhooks.

Note that rejected webhooks (for example due to failed verification if a secret changes)
are preserved and retried for some time,
so can be retried once the secrets are updated.
