---
title: Transistor Episode Stats
layout: home
nav_order: 730
---

# Transistor Episode Stats (`transistor_episode_stats_v1`)

Replicate Transistor Episode Stats into your database.

Docs for this API: [https://developers.transistor.fm/#EpisodeAnalytics](https://developers.transistor.fm/#EpisodeAnalytics)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/transistor_episode_v1.md %}">transistor_episode_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Transistor Episode Stats have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `compound_identity` | `text` | ✅ |
| `episode_id` | `text` |  |
| `date` | `date` |  |
| `downloads` | `integer` |  |
| `row_updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture transistor_episode_stats_v1`.

```sql
CREATE TABLE public.transistor_episode_stats_v1_fixture (
  pk bigserial PRIMARY KEY,
  compound_identity text UNIQUE NOT NULL,
  episode_id text,
  date date,
  downloads integer,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_compound_identity_idx ON public.transistor_episode_stats_v1_fixture (compound_identity);
```

{% include prevnext.html prev='_integrations/stripe_subscription_v1.md' prevLabel='stripe_subscription_v1' next='_integrations/transistor_episode_v1.md' nextLabel='transistor_episode_v1' %}
