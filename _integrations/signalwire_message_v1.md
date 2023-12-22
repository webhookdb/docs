---
title: SignalWire Message
layout: home
nav_order: 550
---

# SignalWire Message (`signalwire_message_v1`)

Replicate SignalWire Messages into your database.

Docs for this API: [https://developer.signalwire.com/compatibility-api/rest/list-all-messages](https://developer.signalwire.com/compatibility-api/rest/list-all-messages)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from SignalWire Messages have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `signalwire_id` | `text` |  |
| `date_created` | `timestamptz` | ✅ |
| `date_sent` | `timestamptz` | ✅ |
| `date_updated` | `timestamptz` | ✅ |
| `direction` | `text` |  |
| `from` | `text` | ✅ |
| `status` | `text` |  |
| `to` | `text` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture signalwire_message_v1`.

```sql
CREATE TABLE public.signalwire_message_v1_fixture (
  pk bigserial PRIMARY KEY,
  signalwire_id text UNIQUE NOT NULL,
  date_created timestamptz,
  date_sent timestamptz,
  date_updated timestamptz,
  direction text,
  "from" text,
  status text,
  "to" text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_date_created_idx ON public.signalwire_message_v1_fixture (date_created);
CREATE INDEX IF NOT EXISTS svi_fixture_date_sent_idx ON public.signalwire_message_v1_fixture (date_sent);
CREATE INDEX IF NOT EXISTS svi_fixture_date_updated_idx ON public.signalwire_message_v1_fixture (date_updated);
CREATE INDEX IF NOT EXISTS svi_fixture_from_idx ON public.signalwire_message_v1_fixture ("from");
CREATE INDEX IF NOT EXISTS svi_fixture_to_idx ON public.signalwire_message_v1_fixture ("to");
```

{% include prevnext.html prev='_integrations/shopify_order_v1.md' prevLabel='shopify_order_v1' next='_integrations/sponsy_customer_v1.md' nextLabel='sponsy_customer_v1' %}
