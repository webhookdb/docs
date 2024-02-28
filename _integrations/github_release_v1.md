---
title: GitHub Release
layout: home
nav_order: 240
---

# GitHub Release (`github_release_v1`)

Replicate GitHub Releases into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create github_release_v1
```

Source documentation for this API: [https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28](https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from GitHub Releases have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `github_id` | `bigint` |  |
| `created_at` | `timestamptz` | ✅ |
| `published_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `node_id` | `text` | ✅ |
| `tag_name` | `text` | ✅ |
| `author_id` | `bigint` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture github_release_v1`.

```sql
CREATE TABLE public.github_release_v1_fixture (
  pk bigserial PRIMARY KEY,
  github_id bigint UNIQUE NOT NULL,
  created_at timestamptz,
  published_at timestamptz,
  row_updated_at timestamptz,
  node_id text,
  tag_name text,
  author_id bigint,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.github_release_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_published_at_idx ON public.github_release_v1_fixture (published_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.github_release_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_node_id_idx ON public.github_release_v1_fixture (node_id);
CREATE INDEX IF NOT EXISTS svi_fixture_tag_name_idx ON public.github_release_v1_fixture (tag_name);
CREATE INDEX IF NOT EXISTS svi_fixture_author_id_idx ON public.github_release_v1_fixture (author_id);
```

{% include prevnext.html prev='_integrations/github_pull_v1.md' prevLabel='github_pull_v1' next='_integrations/github_repository_event_v1.md' nextLabel='github_repository_event_v1' %}
