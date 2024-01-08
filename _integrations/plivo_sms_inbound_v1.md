---
title: Plivo Inbound SMS Message
layout: home
nav_order: 550
---

# Plivo Inbound SMS Message (`plivo_sms_inbound_v1`)

Replicate Plivo Inbound SMS Messages into your database.

Docs for this API: [https://www.plivo.com/docs/sms/api/message#the-message-object](https://www.plivo.com/docs/sms/api/message#the-message-object)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from Plivo Inbound SMS Messages have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `plivo_message_uuid` | `text` |  |
| `row_inserted_at` | `timestamptz` | ✅ |
| `from_number` | `text` | ✅ |
| `to_number` | `text` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture plivo_sms_inbound_v1`.

```sql
CREATE TABLE public.plivo_sms_inbound_v1_fixture (
  pk bigserial PRIMARY KEY,
  plivo_message_uuid text UNIQUE NOT NULL,
  row_inserted_at timestamptz,
  from_number text,
  to_number text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_row_inserted_at_idx ON public.plivo_sms_inbound_v1_fixture (row_inserted_at);
CREATE INDEX IF NOT EXISTS svi_fixture_from_number_idx ON public.plivo_sms_inbound_v1_fixture (from_number);
CREATE INDEX IF NOT EXISTS svi_fixture_to_number_idx ON public.plivo_sms_inbound_v1_fixture (to_number);
```

{% include prevnext.html prev='_integrations/plaid_transaction_v1.md' prevLabel='plaid_transaction_v1' next='_integrations/postmark_inbound_message_v1.md' nextLabel='postmark_inbound_message_v1' %}
