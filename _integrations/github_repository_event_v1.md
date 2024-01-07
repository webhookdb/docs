---
title: GitHub Repository Activity Event
layout: home
nav_order: 170
---

# GitHub Repository Activity Event (`github_repository_event_v1`)

Replicate GitHub Repository Activity Events into your database.

Docs for this API: [https://docs.github.com/en/rest/activity/events?apiVersion=2022-11-28](https://docs.github.com/en/rest/activity/events?apiVersion=2022-11-28)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from GitHub Repository Activity Events have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `github_id` | `text` |  |
| `type` | `text` | ✅ |
| `created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `actor_id` | `bigint` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture github_repository_event_v1`.

```sql
CREATE TABLE public.github_repository_event_v1_fixture (
  pk bigserial PRIMARY KEY,
  github_id text UNIQUE NOT NULL,
  type text,
  created_at timestamptz,
  row_updated_at timestamptz,
  actor_id bigint,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_type_idx ON public.github_repository_event_v1_fixture (type);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.github_repository_event_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.github_repository_event_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_actor_id_idx ON public.github_repository_event_v1_fixture (actor_id);
```

{% include prevnext.html prev='_integrations/github_release_v1.md' prevLabel='github_release_v1' next='_integrations/icalendar_calendar_v1.md' nextLabel='icalendar_calendar_v1' %}
