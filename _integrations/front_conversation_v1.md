---
title: Front Conversation
layout: home
nav_order: 170
---

# Front Conversation (`front_conversation_v1`)

Replicate Front Conversations into your database.

Docs for this API: [https://dev.frontapp.com/reference/conversations](https://dev.frontapp.com/reference/conversations)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/front_marketplace_root_v1.md %}">front_marketplace_root_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from Front Conversations have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `front_id` | `text` |  |
| `subject` | `text` |  |
| `status` | `text` |  |
| `created_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture front_conversation_v1`.

```sql
CREATE TABLE public.front_conversation_v1_fixture (
  pk bigserial PRIMARY KEY,
  front_id text UNIQUE NOT NULL,
  subject text,
  status text,
  created_at timestamptz,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/email_octopus_list_v1.md' prevLabel='email_octopus_list_v1' next='_integrations/front_marketplace_root_v1.md' nextLabel='front_marketplace_root_v1' %}