---
title: Auth
layout: home
parent: Calling the API
---

# Auth

All the endpoints listed in this section work with a special type of auth
that uses your WebhookDB connection string. This avoids extra work managing secrets,
since you already need to manage the WebhookDB connection string secret.

To auth with the rest of the endpoints documented here (querying the database,
enquing a backfill job), set the `Whdb-Sha256-Connstr` header to a SHA256 hex hash of the connection string.
For example:

```bash
$ export WHDB_CONNSTR=postgres://x:y@mydb.webhookdb.com/z
$ export WHDB_SHA256=`echo -n "${WHDB_CONNSTR}" | shasum -a 256 | cut -f 1 -d " "`
$ curl -X POST \
  -d '{"query":"SELECT * FROM stripe_charge_v1_abc0}' \
  -H "Content-Type: application/json" \
  -H "Whdb-Sha256-Connstr: ${WHDB_SHA256}" \ 
  https://api.webhookdb.com/v1/db/my_org/sql 
```
