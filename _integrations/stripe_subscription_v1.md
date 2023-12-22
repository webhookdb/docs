---
title: Stripe Subscription
layout: home
nav_order: 720
---

# Stripe Subscription (`stripe_subscription_v1`)

Replicate Stripe Subscriptions into your database.

Docs for this API: [https://stripe.com/docs/api/subscriptions](https://stripe.com/docs/api/subscriptions)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Stripe Subscriptions have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `stripe_id` | `text` |  |
| `billing_cycle_anchor` | `timestamptz` | ✅ |
| `cancel_at` | `timestamptz` | ✅ |
| `canceled_at` | `timestamptz` | ✅ |
| `created` | `timestamptz` | ✅ |
| `current_period_end` | `timestamptz` | ✅ |
| `current_period_start` | `timestamptz` | ✅ |
| `customer` | `text` | ✅ |
| `default_payment_method` | `text` |  |
| `default_source` | `text` |  |
| `discount` | `text` | ✅ |
| `ended_at` | `timestamptz` | ✅ |
| `latest_invoice` | `text` | ✅ |
| `schedule` | `text` | ✅ |
| `start_date` | `timestamptz` | ✅ |
| `status` | `text` |  |
| `trial_end` | `timestamptz` |  |
| `trial_start` | `timestamptz` |  |
| `updated` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture stripe_subscription_v1`.

```sql
CREATE TABLE public.stripe_subscription_v1_fixture (
  pk bigserial PRIMARY KEY,
  stripe_id text UNIQUE NOT NULL,
  billing_cycle_anchor timestamptz,
  cancel_at timestamptz,
  canceled_at timestamptz,
  created timestamptz,
  current_period_end timestamptz,
  current_period_start timestamptz,
  customer text,
  default_payment_method text,
  default_source text,
  discount text,
  ended_at timestamptz,
  latest_invoice text,
  schedule text,
  start_date timestamptz,
  status text,
  trial_end timestamptz,
  trial_start timestamptz,
  updated timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_billing_cycle_anchor_idx ON public.stripe_subscription_v1_fixture (billing_cycle_anchor);
CREATE INDEX IF NOT EXISTS svi_fixture_cancel_at_idx ON public.stripe_subscription_v1_fixture (cancel_at);
CREATE INDEX IF NOT EXISTS svi_fixture_canceled_at_idx ON public.stripe_subscription_v1_fixture (canceled_at);
CREATE INDEX IF NOT EXISTS svi_fixture_created_idx ON public.stripe_subscription_v1_fixture (created);
CREATE INDEX IF NOT EXISTS svi_fixture_current_period_end_idx ON public.stripe_subscription_v1_fixture (current_period_end);
CREATE INDEX IF NOT EXISTS svi_fixture_current_period_start_idx ON public.stripe_subscription_v1_fixture (current_period_start);
CREATE INDEX IF NOT EXISTS svi_fixture_customer_idx ON public.stripe_subscription_v1_fixture (customer);
CREATE INDEX IF NOT EXISTS svi_fixture_discount_idx ON public.stripe_subscription_v1_fixture (discount);
CREATE INDEX IF NOT EXISTS svi_fixture_ended_at_idx ON public.stripe_subscription_v1_fixture (ended_at);
CREATE INDEX IF NOT EXISTS svi_fixture_latest_invoice_idx ON public.stripe_subscription_v1_fixture (latest_invoice);
CREATE INDEX IF NOT EXISTS svi_fixture_schedule_idx ON public.stripe_subscription_v1_fixture (schedule);
CREATE INDEX IF NOT EXISTS svi_fixture_start_date_idx ON public.stripe_subscription_v1_fixture (start_date);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.stripe_subscription_v1_fixture (updated);
```

{% include prevnext.html prev='_integrations/stripe_subscription_item_v1.md' prevLabel='stripe_subscription_item_v1' next='_integrations/transistor_episode_stats_v1.md' nextLabel='transistor_episode_stats_v1' %}
