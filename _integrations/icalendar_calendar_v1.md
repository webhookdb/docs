---
title: iCalendar Calendar
layout: home
nav_order: 240
---

# iCalendar Calendar (`icalendar_calendar_v1`)

Fetch and convert an icalendar format file into a schematized and queryable database table.

Docs for this API: [https://icalendar.org/](https://icalendar.org/)

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/icalendar_event_v1.md %}">icalendar_event_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from iCalendar Calendars have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `external_id` | `text` |  |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `last_synced_at` | `timestamptz` | ✅ |
| `ics_url` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture icalendar_calendar_v1`.

```sql
CREATE TABLE public.icalendar_calendar_v1_fixture (
  pk bigserial PRIMARY KEY,
  external_id text UNIQUE NOT NULL,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  last_synced_at timestamptz,
  ics_url text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.icalendar_calendar_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.icalendar_calendar_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_last_synced_at_idx ON public.icalendar_calendar_v1_fixture (last_synced_at);
```

{% include prevnext.html prev='_integrations/google_calendar_v1.md' prevLabel='google_calendar_v1' next='_integrations/icalendar_event_v1.md' nextLabel='icalendar_event_v1' %}
