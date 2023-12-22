---
title: Stripe Subscription Item
layout: home
nav_order: 710
---

# Stripe Subscription Item (`stripe_subscription_item_v1`)

Replicate Stripe Subscription Items into your database.

Docs for this API: [https://stripe.com/docs/api/subscription_items](https://stripe.com/docs/api/subscription_items)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Subscription Items have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `created` | `timestamptz` | ✅ |
| `price` | `text` | ✅ |
| `product` | `text` | ✅ |
| `quantity` | `integer` |  |
| `subscription` | `text` | ✅ |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_subscription_item_v1`.

```sql
CREATE TABLE public.stripe_subscription_item_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  created timestamptz,
  price text,
  product text,
  quantity integer,
  subscription text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_subscription_item_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_price_idx ON public.stripe_subscription_item_v1_fixture (price);
CREATE INDEX IF NOT EXISTS svi_fixture_product_idx ON public.stripe_subscription_item_v1_fixture (product);
CREATE INDEX IF NOT EXISTS svi_fixture_subscription_idx ON public.stripe_subscription_item_v1_fixture (subscription);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_subscription_item_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_refund_v1.md' prevLabel='stripe_refund_v1' next='_integrations/stripe_subscription_v1.md' nextLabel='stripe_subscription_v1' %}
