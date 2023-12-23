---
title: Atom Single Feed
layout: home
nav_order: 10
---

# Atom Single Feed (`atom_single_feed_v1`)

Convert any Atom XML feed into a database table for querying and persistent archiving.

Docs for this API: [https://en.wikipedia.org/wiki/Atom_(web_standard)](https://en.wikipedia.org/wiki/Atom_(web_standard))

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Atom Single Feeds have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `entry_id` | `text` |  |
| `row_created_at` | `timestamptz` | ✅ |
| `updated` | `timestamptz` | ✅ |
| `title` | `text` |  |
| `published` | `timestamptz` | ✅ |
| `geo_lat` | `numeric` |  |
| `geo_lng` | `numeric` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture atom_single_feed_v1`.

```sql
CREATE TABLE public.atom_single_feed_v1_fixture (
  pk bigserial PRIMARY KEY,
  entry_id text UNIQUE NOT NULL,
  row_created_at timestamptz,
  updated timestamptz,
  title text,
  published timestamptz,
  geo_lat numeric,
  geo_lng numeric,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.atom_single_feed_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_idx ON public.atom_single_feed_v1_fixture (updated);
CREATE INDEX IF NOT EXISTS svi_fixture_published_idx ON public.atom_single_feed_v1_fixture (published);
```

{% include prevnext.html next='_integrations/aws_pricing_v1.md' nextLabel='aws_pricing_v1' %}
