---
title: Increase Limit
layout: home
nav_order: 360
---

# Increase Limit (`increase_limit_v1`)

Replicate Increase Limits into your database.

Docs for this API: [https://increase.com/documentation/api](https://increase.com/documentation/api)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Increase Limits have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `increase_id` | `text` |  |
| `interval` | `text` |  |
| `metric` | `text` |  |
| `model_id` | `text` | ✅ |
| `model_type` | `text` |  |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `status` | `text` |  |
| `value` | `integer` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture increase_limit_v1`.

```sql
CREATE TABLE public.increase_limit_v1_fixture (
  pk bigserial PRIMARY KEY,
  increase_id text UNIQUE NOT NULL,
  interval text,
  metric text,
  model_id text,
  model_type text,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  status text,
  value integer,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_model_id_idx ON public.increase_limit_v1_fixture (model_id);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.increase_limit_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.increase_limit_v1_fixture (row_updated_at);
```

{% include prevnext.html prev='_integrations/increase_check_transfer_v1.md' prevLabel='increase_check_transfer_v1' next='_integrations/increase_transaction_v1.md' nextLabel='increase_transaction_v1' %}
