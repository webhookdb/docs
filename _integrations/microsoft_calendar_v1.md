---
title: Outlook Calendar
layout: home
nav_order: 440
---

# Outlook Calendar (`microsoft_calendar_v1`)

Replicate Outlook Calendars into your database.

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/microsoft_calendar_user_v1.md %}">microsoft_calendar_user_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/microsoft_calendar_event_v1.md %}">microsoft_calendar_event_v1</a></li>
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

Tables replicated from Outlook Calendars have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `microsoft_calendar_id` | `text` | ✅ |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `microsoft_user_id` | `text` | ✅ |
| `is_default_calendar` | `boolean` |  |
| `delta_url` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture microsoft_calendar_v1`.

```sql
CREATE TABLE public.microsoft_calendar_v1_fixture (
  pk bigserial PRIMARY KEY,
  microsoft_calendar_id text UNIQUE NOT NULL,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  microsoft_user_id text,
  is_default_calendar boolean,
  delta_url text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_microsoft_calendar_id_idx ON public.microsoft_calendar_v1_fixture (microsoft_calendar_id);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.microsoft_calendar_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.microsoft_calendar_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_microsoft_user_id_idx ON public.microsoft_calendar_v1_fixture (microsoft_user_id);
```

{% include prevnext.html prev='_integrations/microsoft_calendar_user_v1.md' prevLabel='microsoft_calendar_user_v1' next='_integrations/nextpax_amenity_code_v1.md' nextLabel='nextpax_amenity_code_v1' %}
