---
title: Increase Wire Transfer
layout: home
nav_order: 330
---

# Increase Wire Transfer (`increase_wire_transfer_v1`)

Replicate Increase Wire Transfers into your database.

Docs for this API: [https://increase.com/documentation/api](https://increase.com/documentation/api)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Increase Wire Transfers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `increase_id` | `text` |  |
| `account_number` | `text` | ✅ |
| `account_id` | `text` | ✅ |
| `amount` | `integer` | ✅ |
| `approved_at` | `timestamptz` |  |
| `created_at` | `timestamptz` | ✅ |
| `routing_number` | `text` | ✅ |
| `status` | `text` |  |
| `template_id` | `text` |  |
| `transaction_id` | `text` | ✅ |
| `updated_at` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture increase_wire_transfer_v1`.

```sql
CREATE TABLE public.increase_wire_transfer_v1_fixture (
  pk bigserial PRIMARY KEY,
  increase_id text UNIQUE NOT NULL,
  account_number text,
  account_id text,
  amount integer,
  approved_at timestamptz,
  created_at timestamptz,
  routing_number text,
  status text,
  template_id text,
  transaction_id text,
  updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_account_number_idx ON public.increase_wire_transfer_v1_fixture (account_number);
CREATE INDEX IF NOT EXISTS svi_fixture_account_id_idx ON public.increase_wire_transfer_v1_fixture (account_id);
CREATE INDEX IF NOT EXISTS svi_fixture_amount_idx ON public.increase_wire_transfer_v1_fixture (amount);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.increase_wire_transfer_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_routing_number_idx ON public.increase_wire_transfer_v1_fixture (routing_number);
CREATE INDEX IF NOT EXISTS svi_fixture_transaction_id_idx ON public.increase_wire_transfer_v1_fixture (transaction_id);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.increase_wire_transfer_v1_fixture (updated_at);
```

{% include prevnext.html prev='_integrations/increase_transaction_v1.md' prevLabel='increase_transaction_v1' next='_integrations/intercom_contact_v1.md' nextLabel='intercom_contact_v1' %}
