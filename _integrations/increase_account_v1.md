---
title: Increase Account
layout: home
nav_order: 330
---

# Increase Account (`increase_account_v1`)

Replicate Increase Accounts into your database.

Docs for this API: [https://increase.com/documentation/api](https://increase.com/documentation/api)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Increase Accounts have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `increase_id` | `text` |  |
| `balance` | `integer` | ✅ |
| `created_at` | `timestamptz` | ✅ |
| `entity_id` | `text` | ✅ |
| `interest_accrued` | `numeric` |  |
| `name` | `text` |  |
| `status` | `text` |  |
| `updated_at` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture increase_account_v1`.

```sql
CREATE TABLE public.increase_account_v1_fixture (
  pk bigserial PRIMARY KEY,
  increase_id text UNIQUE NOT NULL,
  balance integer,
  created_at timestamptz,
  entity_id text,
  interest_accrued numeric,
  name text,
  status text,
  updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_balance_idx ON public.increase_account_v1_fixture (balance);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.increase_account_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_entity_id_idx ON public.increase_account_v1_fixture (entity_id);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.increase_account_v1_fixture (updated_at);
```

{% include prevnext.html prev='_integrations/increase_account_transfer_v1.md' prevLabel='increase_account_transfer_v1' next='_integrations/increase_ach_transfer_v1.md' nextLabel='increase_ach_transfer_v1' %}
