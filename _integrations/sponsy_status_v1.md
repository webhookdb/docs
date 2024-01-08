---
title: Sponsy Status
layout: home
nav_order: 650
---

# Sponsy Status (`sponsy_status_v1`)

Replicate Sponsy Statuses into your database.

Docs for this API: [https://api.getsponsy.com/docs](https://api.getsponsy.com/docs)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/sponsy_publication_v1.md %}">sponsy_publication_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Sponsy Statuses have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `sponsy_id` | `text` |  |
| `publication_id` | `text` | ✅ |
| `name` | `text` |  |
| `slug` | `text` |  |
| `color` | `text` |  |
| `order` | `integer` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture sponsy_status_v1`.

```sql
CREATE TABLE public.sponsy_status_v1_fixture (
  pk bigserial PRIMARY KEY,
  sponsy_id text UNIQUE NOT NULL,
  publication_id text,
  name text,
  slug text,
  color text,
  "order" integer,
  created_at timestamptz,
  updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_publication_id_idx ON public.sponsy_status_v1_fixture (publication_id);
```

{% include prevnext.html prev='_integrations/sponsy_slot_v1.md' prevLabel='sponsy_slot_v1' next='_integrations/stripe_charge_v1.md' nextLabel='stripe_charge_v1' %}
