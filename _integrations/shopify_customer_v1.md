---
title: Shopify Customer
layout: home
nav_order: 530
---

# Shopify Customer (`shopify_customer_v1`)

Replicate Shopify Customers into your database.

Docs for this API: [https://shopify.dev/docs/api/admin-rest/2023-10/resources/customer](https://shopify.dev/docs/api/admin-rest/2023-10/resources/customer)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Shopify Customers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `shopify_id` | `text` |  |
| `created_at` | `timestamptz` | ✅ |
| `email` | `text` | ✅ |
| `first_name` | `text` |  |
| `last_name` | `text` |  |
| `last_order_id` | `text` |  |
| `last_order_name` | `text` |  |
| `phone` | `text` | ✅ |
| `state` | `text` |  |
| `updated_at` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture shopify_customer_v1`.

```sql
CREATE TABLE public.shopify_customer_v1_fixture (
  pk bigserial PRIMARY KEY,
  shopify_id text UNIQUE NOT NULL,
  created_at timestamptz,
  email text,
  first_name text,
  last_name text,
  last_order_id text,
  last_order_name text,
  phone text,
  state text,
  updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.shopify_customer_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_email_idx ON public.shopify_customer_v1_fixture (email);
CREATE INDEX IF NOT EXISTS svi_fixture_phone_idx ON public.shopify_customer_v1_fixture (phone);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.shopify_customer_v1_fixture (updated_at);
```

{% include prevnext.html prev='_integrations/postmark_outbound_message_event_v1.md' prevLabel='postmark_outbound_message_event_v1' next='_integrations/shopify_order_v1.md' nextLabel='shopify_order_v1' %}
