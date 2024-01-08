---
title: GitHub Pull Request
layout: home
nav_order: 220
---

# GitHub Pull Request (`github_pull_v1`)

Replicate GitHub Pull Requests into your database.

Docs for this API: [https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28](https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from GitHub Pull Requests have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `github_id` | `bigint` |  |
| `number` | `integer` | ✅ |
| `created_at` | `timestamptz` | ✅ |
| `updated_at` | `timestamptz` | ✅ |
| `closed_at` | `timestamptz` | ✅ |
| `merged_at` | `timestamptz` | ✅ |
| `state` | `text` |  |
| `user_id` | `bigint` | ✅ |
| `merged_by_id` | `bigint` | ✅ |
| `assignee_ids` | `bigint[]` | ✅ |
| `milestone_number` | `integer` |  |
| `label_ids` | `bigint[]` |  |
| `node_id` | `text` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture github_pull_v1`.

```sql
CREATE TABLE public.github_pull_v1_fixture (
  pk bigserial PRIMARY KEY,
  github_id bigint UNIQUE NOT NULL,
  number integer,
  created_at timestamptz,
  updated_at timestamptz,
  closed_at timestamptz,
  merged_at timestamptz,
  state text,
  user_id bigint,
  merged_by_id bigint,
  assignee_ids bigint[],
  milestone_number integer,
  label_ids bigint[],
  node_id text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_number_idx ON public.github_pull_v1_fixture (number);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.github_pull_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.github_pull_v1_fixture (updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_closed_at_idx ON public.github_pull_v1_fixture (closed_at);
CREATE INDEX IF NOT EXISTS svi_fixture_merged_at_idx ON public.github_pull_v1_fixture (merged_at);
CREATE INDEX IF NOT EXISTS svi_fixture_user_id_idx ON public.github_pull_v1_fixture (user_id);
CREATE INDEX IF NOT EXISTS svi_fixture_merged_by_id_idx ON public.github_pull_v1_fixture (merged_by_id);
CREATE INDEX IF NOT EXISTS svi_fixture_assignee_ids_idx ON public.github_pull_v1_fixture (assignee_ids);
CREATE INDEX IF NOT EXISTS svi_fixture_node_id_idx ON public.github_pull_v1_fixture (node_id);
```

{% include prevnext.html prev='_integrations/github_issue_v1.md' prevLabel='github_issue_v1' next='_integrations/github_release_v1.md' nextLabel='github_release_v1' %}
