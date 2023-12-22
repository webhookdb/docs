---
title: Intercom Conversation
layout: home
nav_order: 350
---

# Intercom Conversation (`intercom_conversation_v1`)

Replicate Intercom Conversations into your database.

Docs for this API: [https://developers.intercom.com/docs/references/rest-api/api.intercom.io/Conversations/](https://developers.intercom.com/docs/references/rest-api/api.intercom.io/Conversations/)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/intercom_marketplace_root_v1.md %}">intercom_marketplace_root_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Intercom Conversations have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `intercom_id` | `text` |  |
| `title` | `text` |  |
| `state` | `text` |  |
| `open` | `boolean` |  |
| `read` | `boolean` |  |
| `created_at` | `timestamptz` |  |
| `updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture intercom_conversation_v1`.

```sql
CREATE TABLE public.intercom_conversation_v1_fixture (
  pk bigserial PRIMARY KEY,
  intercom_id text UNIQUE NOT NULL,
  title text,
  state text,
  open boolean,
  read boolean,
  created_at timestamptz,
  updated_at timestamptz,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/intercom_contact_v1.md' prevLabel='intercom_contact_v1' next='_integrations/intercom_marketplace_root_v1.md' nextLabel='intercom_marketplace_root_v1' %}
