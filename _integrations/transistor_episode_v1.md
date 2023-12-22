---
title: Transistor Episode
layout: home
nav_order: 740
---

# Transistor Episode (`transistor_episode_v1`)

Replicate Transistor Episodes into your database.

Docs for this API: [https://developers.transistor.fm/#Episode](https://developers.transistor.fm/#Episode)

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/transistor_episode_stats_v1.md %}">transistor_episode_stats_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Transistor Episodes have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `transistor_id` | `text` |  |
| `author` | `text` |  |
| `created_at` | `timestamptz` | ✅ |
| `duration` | `integer` |  |
| `keywords` | `text` |  |
| `number` | `integer` | ✅ |
| `published_at` | `timestamptz` | ✅ |
| `season` | `integer` | ✅ |
| `show_id` | `text` | ✅ |
| `status` | `text` |  |
| `title` | `text` |  |
| `type` | `text` |  |
| `updated_at` | `timestamptz` | ✅ |
| `api_format` | `integer` |  |
| `logical_summary` | `text` |  |
| `logical_description` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture transistor_episode_v1`.

```sql
CREATE TABLE public.transistor_episode_v1_fixture (
  pk bigserial PRIMARY KEY,
  transistor_id text UNIQUE NOT NULL,
  author text,
  created_at timestamptz,
  duration integer,
  keywords text,
  number integer,
  published_at timestamptz,
  season integer,
  show_id text,
  status text,
  title text,
  type text,
  updated_at timestamptz,
  api_format integer,
  logical_summary text,
  logical_description text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.transistor_episode_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_number_idx ON public.transistor_episode_v1_fixture (number);
CREATE INDEX IF NOT EXISTS svi_fixture_published_at_idx ON public.transistor_episode_v1_fixture (published_at);
CREATE INDEX IF NOT EXISTS svi_fixture_season_idx ON public.transistor_episode_v1_fixture (season);
CREATE INDEX IF NOT EXISTS svi_fixture_show_id_idx ON public.transistor_episode_v1_fixture (show_id);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.transistor_episode_v1_fixture (updated_at);
```

{% include prevnext.html prev='_integrations/transistor_episode_stats_v1.md' prevLabel='transistor_episode_stats_v1' next='_integrations/transistor_show_v1.md' nextLabel='transistor_show_v1' %}
