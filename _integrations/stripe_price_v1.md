---
title: Stripe Price
layout: home
nav_order: 730
---

# Stripe Price (`stripe_price_v1`)

Replicate Stripe Prices into your database.

Docs for this API: [https://stripe.com/docs/api/prices](https://stripe.com/docs/api/prices)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Prices have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `created` | `timestamptz` | ✅ |
| `interval` | `text` |  |
| `product` | `text` |  |
| `type` | `text` |  |
| `unit_amount` | `text` |  |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_price_v1`.

```sql
CREATE TABLE public.stripe_price_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  created timestamptz,
  interval text,
  product text,
  type text,
  unit_amount text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_price_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_price_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_payout_v1.md' prevLabel='stripe_payout_v1' next='_integrations/stripe_product_v1.md' nextLabel='stripe_product_v1' %}
