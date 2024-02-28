---
title: Stripe Payout
layout: home
nav_order: 730
---

# Stripe Payout (`stripe_payout_v1`)

Replicate Stripe Payouts into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create stripe_payout_v1
```

Source documentation for this API: [https://stripe.com/docs/api/payouts](https://stripe.com/docs/api/payouts)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Payouts have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount` | `integer` | ✅ |
| `arrival_date` | `timestamptz` | ✅ |
| `balance_transaction` | `text` | ✅ |
| `created` | `timestamptz` | ✅ |
| `destination` | `text` | ✅ |
| `failure_balance_transaction` | `text` | ✅ |
| `original_payout` | `text` | ✅ |
| `reversed_by` | `text` | ✅ |
| `statement_descriptor` | `text` |  |
| `status` | `text` |  |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_payout_v1`.

```sql
CREATE TABLE public.stripe_payout_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount integer,
  arrival_date timestamptz,
  balance_transaction text,
  created timestamptz,
  destination text,
  failure_balance_transaction text,
  original_payout text,
  reversed_by text,
  statement_descriptor text,
  status text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_amount_idx ON public.stripe_payout_v1_fixture (amount);
CREATE INDEX IF NOT EXISTS svi_fixture_arrival_date_idx ON public.stripe_payout_v1_fixture (arrival_date);
CREATE INDEX IF NOT EXISTS svi_fixture_balance_transaction_idx ON public.stripe_payout_v1_fixture (balance_transaction);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_payout_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_destination_idx ON public.stripe_payout_v1_fixture (destination);
CREATE INDEX IF NOT EXISTS svi_fixture_failure_balance_transaction_idx ON public.stripe_payout_v1_fixture (failure_balance_transaction);
CREATE INDEX IF NOT EXISTS svi_fixture_original_payout_idx ON public.stripe_payout_v1_fixture (original_payout);
CREATE INDEX IF NOT EXISTS svi_fixture_reversed_by_idx ON public.stripe_payout_v1_fixture (reversed_by);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_payout_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_invoice_v1.md' prevLabel='stripe_invoice_v1' next='_integrations/stripe_price_v1.md' nextLabel='stripe_price_v1' %}
