---
title: Schematization
layout: home
---

# Schematization and Normalization

WebhookDB isn't like using Zapier to stuff some webhooks or API requests into a database.
At the core of WebhookDB is that the service **schematizes** and **normalizes** all data.

For example, you never have to worry about the type of a timestamp field.
Timestamps will always be a `TIMESTAMPTZ` column (or whatever your database supports),
no matter whether the API being replicated uses Unix seconds, Unix milliseconds, ISO timestamps, timestamps without timezones, or even a totally weird date format that can't normally be parsed.

Important columns, like foreign keys/references to other resources in the API, are extracted into their own fields and indexed
so you can easily `JOIN` across multiple tables. For example, if you want to see all charges in Stripe
from the last 30 days for your user with an ID of 5, you would run a query like this:

```sql
SELECT cu.* 
FROM stripe_customer_v1_abc0 cu
JOIN stripe_charge_v1_xyz0 ch ON ch.customer_id = cu.stripe_id                                                   
WHERE (cu.data->'metadata'->>'user_id')::BIGINT = 5
AND created > now() - '30 days'::interval
```

Each replicator defines the fields they denormalize, schematize, and index,
and some of the conversions are nontrivial- for example, there are a dozen different formats you'd see in `icalendar` timestamps.
But in WebhookDB, it's always the same easy-to-understand timestamp column.

Check out the Integration pages to see their database schemas.
