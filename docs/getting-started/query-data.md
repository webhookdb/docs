---
title: Query your data
layout: home
parent: Getting started
nav_order: 50
---

# Test your integration and query your data

To check that your integration is working correctly, make a test SQL request
using the WebhookDB CLI.

```
$ webhookdb db sql "SELECT * from stripe_charges_v1_d50b"
```

To see all of the available tables, you can run `\dt` from `psql`:

```
$ psql `webhookdb db connection`
adb12a32d980a1fc13ae93=> \dt
                          List of relations
 Schema |           Name            | Type  |         Owner          
--------+---------------------------+-------+------------------------
 public | stripe_charges_v1_d50b    | table | aro12a9447a625e3179a76
```

Or from the CLI:

```
$ webhookdb db tables
stripe_charges_v1_d50b
```

{% include prevnext.html prev="docs/getting-started/add-integration.md" next="docs/getting-started/backfill.md" %}
