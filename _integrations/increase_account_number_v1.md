---
title: Increase Account Number
layout: home
nav_order: 310
---

# Increase Account Number (`increase_account_number_v1`)

Replicate Increase Account Numbers into your database.

Docs for this API: [https://icalendar.org/](https://icalendar.org/)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Increase Account Numbers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `increase_id` | `text` |  |
| `account_id` | `text` | ✅ |
| `account_number` | `text` | ✅ |
| `name` | `text` |  |
| `routing_number` | `text` | ✅ |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `status` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture increase_account_number_v1`.

```sql
CREATE TABLE public.increase_account_number_v1_fixture (
  pk bigserial PRIMARY KEY,
  increase_id text UNIQUE NOT NULL,
  account_id text,
  account_number text,
  name text,
  routing_number text,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  status text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_account_id_idx ON public.increase_account_number_v1_fixture (account_id);
CREATE INDEX IF NOT EXISTS svi_fixture_account_number_idx ON public.increase_account_number_v1_fixture (account_number);
CREATE INDEX IF NOT EXISTS svi_fixture_routing_number_idx ON public.increase_account_number_v1_fixture (routing_number);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.increase_account_number_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.increase_account_number_v1_fixture (row_updated_at);
```

{% include prevnext.html prev='_integrations/icalendar_event_v1.md' prevLabel='icalendar_event_v1' next='_integrations/increase_account_transfer_v1.md' nextLabel='increase_account_transfer_v1' %}
