---
title: Plaid Item
layout: home
nav_order: 480
---

# Plaid Item (`plaid_item_v1`)

Replicate Plaid Items into your database.

Docs for this API: [https://plaid.com/docs/api/items/](https://plaid.com/docs/api/items/)

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/plaid_transaction_v1.md %}">plaid_transaction_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from Plaid Items have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `plaid_id` | `text` |  |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `transaction_sync_next_cursor` | `text` |  |
| `available_products` | `jsonb` |  |
| `billed_products` | `jsonb` |  |
| `encrypted_access_token` | `text` |  |
| `institution_id` | `text` | ✅ |
| `status` | `jsonb` |  |
| `update_type` | `text` |  |
| `consent_expiration_time` | `timestamptz` | ✅ |
| `error` | `jsonb` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture plaid_item_v1`.

```sql
CREATE TABLE public.plaid_item_v1_fixture (
  pk bigserial PRIMARY KEY,
  plaid_id text UNIQUE NOT NULL,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  transaction_sync_next_cursor text,
  available_products jsonb,
  billed_products jsonb,
  encrypted_access_token text,
  institution_id text,
  status jsonb,
  update_type text,
  consent_expiration_time timestamptz,
  error jsonb,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.plaid_item_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.plaid_item_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_institution_id_idx ON public.plaid_item_v1_fixture (institution_id);
CREATE INDEX IF NOT EXISTS svi_fixture_consent_expiration_time_idx ON public.plaid_item_v1_fixture (consent_expiration_time);
```

{% include prevnext.html prev='_integrations/nextpax_rate_v1.md' prevLabel='nextpax_rate_v1' next='_integrations/plaid_transaction_v1.md' nextLabel='plaid_transaction_v1' %}
