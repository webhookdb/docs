---
title: Sponsy Publication
layout: home
nav_order: 640
---

# Sponsy Publication (`sponsy_publication_v1`)

Replicate Sponsy Publications into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create sponsy_publication_v1
```

Source documentation for this API: [https://api.getsponsy.com/docs](https://api.getsponsy.com/docs)

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/sponsy_placement_v1.md %}">sponsy_placement_v1</a></li>
<li><a href="{% link _integrations/sponsy_slot_v1.md %}">sponsy_slot_v1</a></li>
<li><a href="{% link _integrations/sponsy_status_v1.md %}">sponsy_status_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Sponsy Publications have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `sponsy_id` | `text` |  |
| `name` | `text` |  |
| `slug` | `text` |  |
| `type` | `text` |  |
| `deleted_at` | `timestamptz` |  |
| `days` | `integer[]` |  |
| `days_normalized` | `integer[]` |  |
| `day_names` | `text[]` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture sponsy_publication_v1`.

```sql
CREATE TABLE public.sponsy_publication_v1_fixture (
  pk bigserial PRIMARY KEY,
  sponsy_id text UNIQUE NOT NULL,
  name text,
  slug text,
  type text,
  deleted_at timestamptz,
  days integer[],
  days_normalized integer[],
  day_names text[],
  created_at timestamptz,
  updated_at timestamptz,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/sponsy_placement_v1.md' prevLabel='sponsy_placement_v1' next='_integrations/sponsy_slot_v1.md' nextLabel='sponsy_slot_v1' %}
