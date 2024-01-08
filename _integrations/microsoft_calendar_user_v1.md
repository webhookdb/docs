---
title: Outlook Calendar User
layout: home
nav_order: 430
---

# Outlook Calendar User (`microsoft_calendar_user_v1`)

Replicate Outlook Calendar Users into your database.

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/microsoft_calendar_v1.md %}">microsoft_calendar_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from Outlook Calendar Users have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `microsoft_user_id` | `text` |  |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `encrypted_refresh_token` | `text` |  |
| `events_subscription_id` | `text` | ✅ |
| `events_subscription_expiration` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture microsoft_calendar_user_v1`.

```sql
CREATE TABLE public.microsoft_calendar_user_v1_fixture (
  pk bigserial PRIMARY KEY,
  microsoft_user_id text UNIQUE NOT NULL,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  encrypted_refresh_token text,
  events_subscription_id text,
  events_subscription_expiration timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.microsoft_calendar_user_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.microsoft_calendar_user_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_events_subscription_id_idx ON public.microsoft_calendar_user_v1_fixture (events_subscription_id);
CREATE INDEX IF NOT EXISTS svi_fixture_events_subscription_expiration_idx ON public.microsoft_calendar_user_v1_fixture (events_subscription_expiration);
```

{% include prevnext.html prev='_integrations/microsoft_calendar_event_v1.md' prevLabel='microsoft_calendar_event_v1' next='_integrations/microsoft_calendar_v1.md' nextLabel='microsoft_calendar_v1' %}
