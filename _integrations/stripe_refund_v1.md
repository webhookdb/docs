---
title: Stripe Refund
layout: home
nav_order: 760
---

# Stripe Refund (`stripe_refund_v1`)

Replicate Stripe Refunds into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create stripe_refund_v1
```

Source documentation for this API: [https://stripe.com/docs/api/refunds](https://stripe.com/docs/api/refunds)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Refunds have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount` | `integer` | ✅ |
| `balance_transaction` | `text` | ✅ |
| `charge` | `text` | ✅ |
| `created` | `timestamptz` | ✅ |
| `payment_intent` | `text` | ✅ |
| `receipt_number` | `text` | ✅ |
| `source_transfer_reversal` | `text` | ✅ |
| `status` | `text` |  |
| `transfer_reversal` | `text` | ✅ |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_refund_v1`.

```sql
CREATE TABLE public.stripe_refund_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount integer,
  balance_transaction text,
  charge text,
  created timestamptz,
  payment_intent text,
  receipt_number text,
  source_transfer_reversal text,
  status text,
  transfer_reversal text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_amount_idx ON public.stripe_refund_v1_fixture (amount);
CREATE INDEX IF NOT EXISTS svi_fixture_balance_transaction_idx ON public.stripe_refund_v1_fixture (balance_transaction);
CREATE INDEX IF NOT EXISTS svi_fixture_charge_idx ON public.stripe_refund_v1_fixture (charge);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_refund_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_payment_intent_idx ON public.stripe_refund_v1_fixture (payment_intent);
CREATE INDEX IF NOT EXISTS svi_fixture_receipt_number_idx ON public.stripe_refund_v1_fixture (receipt_number);
CREATE INDEX IF NOT EXISTS svi_fixture_source_transfer_reversal_idx ON public.stripe_refund_v1_fixture (source_transfer_reversal);
CREATE INDEX IF NOT EXISTS svi_fixture_transfer_reversal_idx ON public.stripe_refund_v1_fixture (transfer_reversal);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_refund_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_product_v1.md' prevLabel='stripe_product_v1' next='_integrations/stripe_subscription_item_v1.md' nextLabel='stripe_subscription_item_v1' %}
