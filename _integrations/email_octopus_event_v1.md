---
title: Email Octopus Event
layout: home
nav_order: 150
---

# Email Octopus Event (`email_octopus_event_v1`)

Replicate Email Octopus Events into your database.

Docs for this API: [https://emailoctopus.com/api-documentation](https://emailoctopus.com/api-documentation)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/email_octopus_list_v1.md %}">email_octopus_list_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Email Octopus Events have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `unique_id` | `uuid` |  |
| `email_octopus_contact_id` | `text` |  |
| `contact_email_address` | `text` |  |
| `email_octopus_campaign_id` | `text` |  |
| `event_type` | `text` |  |
| `occurred_at` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture email_octopus_event_v1`.

```sql
CREATE TABLE public.email_octopus_event_v1_fixture (
  pk bigserial PRIMARY KEY,
  unique_id uuid UNIQUE NOT NULL,
  email_octopus_contact_id text,
  contact_email_address text,
  email_octopus_campaign_id text,
  event_type text,
  occurred_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_occurred_at_idx ON public.email_octopus_event_v1_fixture (occurred_at);
```

{% include prevnext.html prev='_integrations/email_octopus_contact_v1.md' prevLabel='email_octopus_contact_v1' next='_integrations/email_octopus_list_v1.md' nextLabel='email_octopus_list_v1' %}
