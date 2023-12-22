---
title: Plaid Transaction
layout: home
nav_order: 490
---

# Plaid Transaction (`plaid_transaction_v1`)

Replicate Plaid Transactions into your database.

Docs for this API: [https://plaid.com/docs/api/products/transactions/](https://plaid.com/docs/api/products/transactions/)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/plaid_item_v1.md %}">plaid_item_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from Plaid Transactions have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `plaid_id` | `text` |  |
| `item_id` | `text` | ✅ |
| `account_id` | `text` | ✅ |
| `amount` | `text` |  |
| `iso_currency_code` | `text` |  |
| `date` | `date` | ✅ |
| `removed_at` | `timestamptz` |  |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture plaid_transaction_v1`.

```sql
CREATE TABLE public.plaid_transaction_v1_fixture (
  pk bigserial PRIMARY KEY,
  plaid_id text UNIQUE NOT NULL,
  item_id text,
  account_id text,
  amount text,
  iso_currency_code text,
  date date,
  removed_at timestamptz,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_item_id_idx ON public.plaid_transaction_v1_fixture (item_id);
CREATE INDEX IF NOT EXISTS svi_fixture_account_id_idx ON public.plaid_transaction_v1_fixture (account_id);
CREATE INDEX IF NOT EXISTS svi_fixture_date_idx ON public.plaid_transaction_v1_fixture (date);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.plaid_transaction_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.plaid_transaction_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_account_id_date_amount_idx ON public.plaid_transaction_v1_fixture (account_id, date, amount);
```

{% include prevnext.html prev='_integrations/plaid_item_v1.md' prevLabel='plaid_item_v1' next='_integrations/plivo_sms_inbound_v1.md' nextLabel='plivo_sms_inbound_v1' %}
