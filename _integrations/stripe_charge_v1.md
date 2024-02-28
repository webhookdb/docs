---
title: Stripe Charge
layout: home
nav_order: 670
---

# Stripe Charge (`stripe_charge_v1`)

Replicate Stripe Charges into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create stripe_charge_v1
```

Source documentation for this API: [https://stripe.com/docs/api/charges](https://stripe.com/docs/api/charges)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Charges have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount` | `integer` | ✅ |
| `balance_transaction` | `text` | ✅ |
| `billing_email` | `text` | ✅ |
| `created` | `timestamptz` | ✅ |
| `customer` | `text` | ✅ |
| `invoice` | `text` | ✅ |
| `payment_type` | `text` |  |
| `receipt_email` | `text` | ✅ |
| `status` | `text` | ✅ |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_charge_v1`.

```sql
CREATE TABLE public.stripe_charge_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount integer,
  balance_transaction text,
  billing_email text,
  created timestamptz,
  customer text,
  invoice text,
  payment_type text,
  receipt_email text,
  status text,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_amount_idx ON public.stripe_charge_v1_fixture (amount);
CREATE INDEX IF NOT EXISTS svi_fixture_balance_transaction_idx ON public.stripe_charge_v1_fixture (balance_transaction);
CREATE INDEX IF NOT EXISTS svi_fixture_billing_email_idx ON public.stripe_charge_v1_fixture (billing_email);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_charge_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_idx ON public.stripe_charge_v1_fixture (customer);
CREATE INDEX IF NOT EXISTS svi_fixture_invoice_idx ON public.stripe_charge_v1_fixture (invoice);
CREATE INDEX IF NOT EXISTS svi_fixture_receipt_email_idx ON public.stripe_charge_v1_fixture (receipt_email);
CREATE INDEX IF NOT EXISTS svi_fixture_status_idx ON public.stripe_charge_v1_fixture (status);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_charge_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/sponsy_status_v1.md' prevLabel='sponsy_status_v1' next='_integrations/stripe_coupon_v1.md' nextLabel='stripe_coupon_v1' %}
