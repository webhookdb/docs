---
title: Stripe Coupon
layout: home
nav_order: 670
---

# Stripe Coupon (`stripe_coupon_v1`)

Replicate Stripe Coupons into your database.

Docs for this API: [https://stripe.com/docs/api/coupons](https://stripe.com/docs/api/coupons)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Coupons have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount_off` | `text` |  |
| `created` | `timestamptz` | ✅ |
| `duration` | `text` |  |
| `max_redemptions` | `integer` |  |
| `name` | `text` |  |
| `percent_off` | `numeric` |  |
| `times_redeemed` | `numeric` |  |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_coupon_v1`.

```sql
CREATE TABLE public.stripe_coupon_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount_off text,
  created timestamptz,
  duration text,
  max_redemptions integer,
  name text,
  percent_off numeric,
  times_redeemed numeric,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_coupon_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_coupon_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_charge_v1.md' prevLabel='stripe_charge_v1' next='_integrations/stripe_customer_v1.md' nextLabel='stripe_customer_v1' %}
