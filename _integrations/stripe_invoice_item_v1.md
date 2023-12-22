---
title: Stripe Invoice Item
layout: home
nav_order: 650
---

# Stripe Invoice Item (`stripe_invoice_item_v1`)

Replicate Stripe Invoice Items into your database.

Docs for this API: [https://stripe.com/docs/api/invoiceitems](https://stripe.com/docs/api/invoiceitems)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Invoice Items have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount` | `integer` | ✅ |
| `customer` | `text` | ✅ |
| `date` | `timestamptz` | ✅ |
| `description` | `text` |  |
| `invoice` | `text` | ✅ |
| `period_end` | `timestamptz` | ✅ |
| `period_start` | `timestamptz` | ✅ |
| `price` | `text` | ✅ |
| `product` | `text` | ✅ |
| `quantity` | `integer` |  |
| `subscription` | `text` | ✅ |
| `subscription_item` | `text` | ✅ |
| `unit_amount` | `integer` |  |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_invoice_item_v1`.

```sql
CREATE TABLE public.stripe_invoice_item_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount integer,
  customer text,
  date timestamptz,
  description text,
  invoice text,
  period_end timestamptz,
  period_start timestamptz,
  price text,
  product text,
  quantity integer,
  subscription text,
  subscription_item text,
  unit_amount integer,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_amount_idx ON public.stripe_invoice_item_v1_fixture (amount);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_idx ON public.stripe_invoice_item_v1_fixture (customer);
CREATE INDEX IF NOT EXISTS svi_fixture_date_idx ON public.stripe_invoice_item_v1_fixture (date);
CREATE INDEX IF NOT EXISTS svi_fixture_invoice_idx ON public.stripe_invoice_item_v1_fixture (invoice);
CREATE INDEX IF NOT EXISTS svi_fixture_period_end_idx ON public.stripe_invoice_item_v1_fixture (period_end);
CREATE INDEX IF NOT EXISTS svi_fixture_period_start_idx ON public.stripe_invoice_item_v1_fixture (period_start);
CREATE INDEX IF NOT EXISTS svi_fixture_price_idx ON public.stripe_invoice_item_v1_fixture (price);
CREATE INDEX IF NOT EXISTS svi_fixture_product_idx ON public.stripe_invoice_item_v1_fixture (product);
CREATE INDEX IF NOT EXISTS svi_fixture_subscription_idx ON public.stripe_invoice_item_v1_fixture (subscription);
CREATE INDEX IF NOT EXISTS svi_fixture_subscription_item_idx ON public.stripe_invoice_item_v1_fixture (subscription_item);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_invoice_item_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_dispute_v1.md' prevLabel='stripe_dispute_v1' next='_integrations/stripe_invoice_v1.md' nextLabel='stripe_invoice_v1' %}
