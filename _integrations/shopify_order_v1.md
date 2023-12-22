---
title: Shopify Order
layout: home
nav_order: 540
---

# Shopify Order (`shopify_order_v1`)

Replicate Shopify Orders into your database.

Docs for this API: [https://shopify.dev/docs/api/admin-rest/2023-10/resources/order](https://shopify.dev/docs/api/admin-rest/2023-10/resources/order)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Shopify Orders have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `shopify_id` | `text` |  |
| `app_id` | `text` |  |
| `cancelled_at` | `timestamptz` | ✅ |
| `cart_token` | `text` |  |
| `checkout_token` | `text` |  |
| `closed_at` | `timestamptz` | ✅ |
| `created_at` | `timestamptz` | ✅ |
| `customer_id` | `text` | ✅ |
| `email` | `text` | ✅ |
| `name` | `text` |  |
| `order_number` | `integer` | ✅ |
| `phone` | `text` | ✅ |
| `token` | `text` |  |
| `updated_at` | `timestamptz` | ✅ |
| `user_id` | `text` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture shopify_order_v1`.

```sql
CREATE TABLE public.shopify_order_v1_fixture (
  pk bigserial PRIMARY KEY,
  shopify_id text UNIQUE NOT NULL,
  app_id text,
  cancelled_at timestamptz,
  cart_token text,
  checkout_token text,
  closed_at timestamptz,
  created_at timestamptz,
  customer_id text,
  email text,
  name text,
  order_number integer,
  phone text,
  token text,
  updated_at timestamptz,
  user_id text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_cancelled_at_idx ON public.shopify_order_v1_fixture (cancelled_at);
CREATE INDEX IF NOT EXISTS svi_fixture_closed_at_idx ON public.shopify_order_v1_fixture (closed_at);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.shopify_order_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_id_idx ON public.shopify_order_v1_fixture (customer_id);
CREATE INDEX IF NOT EXISTS svi_fixture_email_idx ON public.shopify_order_v1_fixture (email);
CREATE INDEX IF NOT EXISTS svi_fixture_order_number_idx ON public.shopify_order_v1_fixture (order_number);
CREATE INDEX IF NOT EXISTS svi_fixture_phone_idx ON public.shopify_order_v1_fixture (phone);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.shopify_order_v1_fixture (updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_user_id_idx ON public.shopify_order_v1_fixture (user_id);
```

{% include prevnext.html prev='_integrations/shopify_customer_v1.md' prevLabel='shopify_customer_v1' next='_integrations/signalwire_message_v1.md' nextLabel='signalwire_message_v1' %}
