---
title: Stripe Invoice
layout: home
nav_order: 720
---

# Stripe Invoice (`stripe_invoice_v1`)

Replicate Stripe Invoices into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create stripe_invoice_v1
```

Source documentation for this API: [https://stripe.com/docs/api/invoices](https://stripe.com/docs/api/invoices)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Invoices have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `amount_due` | `integer` |  |
| `amount_paid` | `integer` |  |
| `amount_remaining` | `integer` |  |
| `charge` | `text` | ✅ |
| `created` | `timestamptz` | ✅ |
| `customer` | `text` | ✅ |
| `customer_address` | `text` |  |
| `customer_email` | `text` | ✅ |
| `customer_name` | `text` |  |
| `customer_phone` | `text` | ✅ |
| `customer_shipping` | `text` |  |
| `number` | `text` | ✅ |
| `period_start` | `timestamptz` | ✅ |
| `period_end` | `timestamptz` | ✅ |
| `statement_descriptor` | `text` |  |
| `status` | `text` |  |
| `status_transitions_finalized_at` | `timestamptz` | ✅ |
| `status_transitions_marked_uncollectible_at` | `timestamptz` | ✅ |
| `status_transitions_marked_paid_at` | `timestamptz` | ✅ |
| `status_transitions_voided_at` | `timestamptz` | ✅ |
| `subtotal` | `integer` | ✅ |
| `tax` | `integer` | ✅ |
| `total` | `integer` | ✅ |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_invoice_v1`.

```sql
CREATE TABLE public.stripe_invoice_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  amount_due integer,
  amount_paid integer,
  amount_remaining integer,
  charge text,
  created timestamptz,
  customer text,
  customer_address text,
  customer_email text,
  customer_name text,
  customer_phone text,
  customer_shipping text,
  number text,
  period_start timestamptz,
  period_end timestamptz,
  statement_descriptor text,
  status text,
  status_transitions_finalized_at timestamptz,
  status_transitions_marked_uncollectible_at timestamptz,
  status_transitions_marked_paid_at timestamptz,
  status_transitions_voided_at timestamptz,
  subtotal integer,
  tax integer,
  total integer,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_charge_idx ON public.stripe_invoice_v1_fixture (charge);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_invoice_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_idx ON public.stripe_invoice_v1_fixture (customer);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_email_idx ON public.stripe_invoice_v1_fixture (customer_email);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_phone_idx ON public.stripe_invoice_v1_fixture (customer_phone);
CREATE INDEX IF NOT EXISTS svi_fixture_number_idx ON public.stripe_invoice_v1_fixture (number);
CREATE INDEX IF NOT EXISTS svi_fixture_period_start_idx ON public.stripe_invoice_v1_fixture (period_start);
CREATE INDEX IF NOT EXISTS svi_fixture_period_end_idx ON public.stripe_invoice_v1_fixture (period_end);
CREATE INDEX IF NOT EXISTS svi_fixture_status_transitions_finalized_at_idx ON public.stripe_invoice_v1_fixture (status_transitions_finalized_at);
CREATE INDEX IF NOT EXISTS svi_fixture_status_transitions_marked_uncollectible_at_idx ON public.stripe_invoice_v1_fixture (status_transitions_marked_uncollectible_at);
CREATE INDEX IF NOT EXISTS svi_fixture_status_transitions_marked_paid_at_idx ON public.stripe_invoice_v1_fixture (status_transitions_marked_paid_at);
CREATE INDEX IF NOT EXISTS svi_fixture_status_transitions_voided_at_idx ON public.stripe_invoice_v1_fixture (status_transitions_voided_at);
CREATE INDEX IF NOT EXISTS svi_fixture_subtotal_idx ON public.stripe_invoice_v1_fixture (subtotal);
CREATE INDEX IF NOT EXISTS svi_fixture_tax_idx ON public.stripe_invoice_v1_fixture (tax);
CREATE INDEX IF NOT EXISTS svi_fixture_total_idx ON public.stripe_invoice_v1_fixture (total);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_invoice_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_invoice_item_v1.md' prevLabel='stripe_invoice_item_v1' next='_integrations/stripe_payout_v1.md' nextLabel='stripe_payout_v1' %}
