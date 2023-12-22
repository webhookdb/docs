---
title: Email Octopus List
layout: home
nav_order: 160
---

# Email Octopus List (`email_octopus_list_v1`)

Replicate Email Octopus Lists into your database.

Docs for this API: [https://emailoctopus.com/api-documentation](https://emailoctopus.com/api-documentation)

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/email_octopus_campaign_v1.md %}">email_octopus_campaign_v1</a></li>
<li><a href="{% link _integrations/email_octopus_contact_v1.md %}">email_octopus_contact_v1</a></li>
<li><a href="{% link _integrations/email_octopus_event_v1.md %}">email_octopus_event_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Email Octopus Lists have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `email_octopus_id` | `text` |  |
| `name` | `text` |  |
| `created_at` | `timestamptz` | ✅ |
| `pending` | `integer` |  |
| `subscribed` | `integer` |  |
| `unsubscribed` | `integer` |  |
| `row_updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture email_octopus_list_v1`.

```sql
CREATE TABLE public.email_octopus_list_v1_fixture (
  pk bigserial PRIMARY KEY,
  email_octopus_id text UNIQUE NOT NULL,
  name text,
  created_at timestamptz,
  pending integer,
  subscribed integer,
  unsubscribed integer,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.email_octopus_list_v1_fixture (created_at);
```

{% include prevnext.html prev='_integrations/email_octopus_event_v1.md' prevLabel='email_octopus_event_v1' next='_integrations/front_conversation_v1.md' nextLabel='front_conversation_v1' %}
