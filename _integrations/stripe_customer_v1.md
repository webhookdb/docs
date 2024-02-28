---
title: Stripe Customer
layout: home
nav_order: 690
---

# Stripe Customer (`stripe_customer_v1`)

Replicate Stripe Customers into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create stripe_customer_v1
```

Source documentation for this API: [https://stripe.com/docs/api/customers](https://stripe.com/docs/api/customers)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Customers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `balance` | `integer` | ✅ |
| `created` | `timestamptz` | ✅ |
| `email` | `text` | ✅ |
| `name` | `text` |  |
| `phone` | `text` | ✅ |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_customer_v1`.

```sql
CREATE TABLE public.stripe_customer_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  balance integer,
  created timestamptz,
  email text,
  name text,
  phone text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_balance_idx ON public.stripe_customer_v1_fixture (balance);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_customer_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_email_idx ON public.stripe_customer_v1_fixture (email);
CREATE INDEX IF NOT EXISTS svi_fixture_phone_idx ON public.stripe_customer_v1_fixture (phone);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_customer_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_coupon_v1.md' prevLabel='stripe_coupon_v1' next='_integrations/stripe_dispute_v1.md' nextLabel='stripe_dispute_v1' %}
