---
title: Sponsy Customer
layout: home
nav_order: 610
---

# Sponsy Customer (`sponsy_customer_v1`)

Replicate Sponsy Customers into your database.

Docs for this API: [https://api.getsponsy.com/docs](https://api.getsponsy.com/docs)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/sponsy_slot_v1.md %}">sponsy_slot_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Sponsy Customers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `sponsy_id` | `text` |  |
| `name` | `text` |  |
| `logo` | `text` |  |
| `notes` | `text` |  |
| `portal_text` | `text` |  |
| `portal_id` | `text` | ✅ |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture sponsy_customer_v1`.

```sql
CREATE TABLE public.sponsy_customer_v1_fixture (
  pk bigserial PRIMARY KEY,
  sponsy_id text UNIQUE NOT NULL,
  name text,
  logo text,
  notes text,
  portal_text text,
  portal_id text,
  created_at timestamptz,
  updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_portal_id_idx ON public.sponsy_customer_v1_fixture (portal_id);
```

{% include prevnext.html prev='_integrations/signalwire_message_v1.md' prevLabel='signalwire_message_v1' next='_integrations/sponsy_placement_v1.md' nextLabel='sponsy_placement_v1' %}
