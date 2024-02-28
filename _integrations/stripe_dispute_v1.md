---
title: Stripe Dispute
layout: home
nav_order: 700
---

# Stripe Dispute (`stripe_dispute_v1`)

Replicate Stripe Disputes into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create stripe_dispute_v1
```

Source documentation for this API: [https://stripe.com/docs/api/disputes](https://stripe.com/docs/api/disputes)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Disputes have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount` | `integer` |  |
| `charge` | `text` |  |
| `cancellation_policy` | `text` |  |
| `created` | `timestamptz` | ✅ |
| `due_by` | `timestamptz` |  |
| `is_charge_refundable` | `text` |  |
| `receipt` | `text` |  |
| `refund_policy` | `text` |  |
| `service_date` | `timestamptz` |  |
| `status` | `text` |  |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_dispute_v1`.

```sql
CREATE TABLE public.stripe_dispute_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount integer,
  charge text,
  cancellation_policy text,
  created timestamptz,
  due_by timestamptz,
  is_charge_refundable text,
  receipt text,
  refund_policy text,
  service_date timestamptz,
  status text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_dispute_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_dispute_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_customer_v1.md' prevLabel='stripe_customer_v1' next='_integrations/stripe_invoice_item_v1.md' nextLabel='stripe_invoice_item_v1' %}
