---
title: GitHub Issue Comment
layout: home
nav_order: 200
---

# GitHub Issue Comment (`github_issue_comment_v1`)

Replicate GitHub Issue Comments into your database.

Docs for this API: [https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28](https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from GitHub Issue Comments have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `github_id` | `bigint` |  |
| `issue_id` | `bigint` | ✅ |
| `created_at` | `timestamptz` | ✅ |
| `updated_at` | `timestamptz` | ✅ |
| `user_id` | `bigint` | ✅ |
| `node_id` | `text` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture github_issue_comment_v1`.

```sql
CREATE TABLE public.github_issue_comment_v1_fixture (
  pk bigserial PRIMARY KEY,
  github_id bigint UNIQUE NOT NULL,
  issue_id bigint,
  created_at timestamptz,
  updated_at timestamptz,
  user_id bigint,
  node_id text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_issue_id_idx ON public.github_issue_comment_v1_fixture (issue_id);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.github_issue_comment_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.github_issue_comment_v1_fixture (updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_user_id_idx ON public.github_issue_comment_v1_fixture (user_id);
CREATE INDEX IF NOT EXISTS svi_fixture_node_id_idx ON public.github_issue_comment_v1_fixture (node_id);
```

{% include prevnext.html prev='_integrations/front_message_v1.md' prevLabel='front_message_v1' next='_integrations/github_issue_v1.md' nextLabel='github_issue_v1' %}
