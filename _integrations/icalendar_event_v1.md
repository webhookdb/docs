---
title: iCalendar Event
layout: home
nav_order: 300
---

# iCalendar Event (`icalendar_event_v1`)

Individual events in an icalendar. See icalendar_calendar_v1.

Docs for this API: [https://icalendar.org/](https://icalendar.org/)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/icalendar_calendar_v1.md %}">icalendar_calendar_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from iCalendar Events have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `compound_identity` | `text` | ✅ |
| `calendar_external_id` | `text` | ✅ |
| `uid` | `text` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `last_modified_at` | `timestamptz` | ✅ |
| `created_at` | `timestamptz` |  |
| `start_at` | `timestamptz` | ✅ |
| `missing_timezone` | `boolean` |  |
| `end_at` | `timestamptz` | ✅ |
| `start_date` | `date` | ✅ |
| `end_date` | `date` | ✅ |
| `status` | `text` |  |
| `categories` | `text[]` |  |
| `priority` | `integer` |  |
| `geo_lat` | `numeric` |  |
| `geo_lng` | `numeric` |  |
| `classification` | `text` |  |
| `recurring_event_id` | `text` | ✅ |
| `recurring_event_sequence` | `integer` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture icalendar_event_v1`.

```sql
CREATE TABLE public.icalendar_event_v1_fixture (
  pk bigserial PRIMARY KEY,
  compound_identity text UNIQUE NOT NULL,
  calendar_external_id text,
  uid text,
  row_updated_at timestamptz,
  last_modified_at timestamptz,
  created_at timestamptz,
  start_at timestamptz,
  missing_timezone boolean,
  end_at timestamptz,
  start_date date,
  end_date date,
  status text,
  categories text[],
  priority integer,
  geo_lat numeric,
  geo_lng numeric,
  classification text,
  recurring_event_id text,
  recurring_event_sequence integer,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_compound_identity_idx ON public.icalendar_event_v1_fixture (compound_identity);
CREATE INDEX IF NOT EXISTS svi_fixture_calendar_external_id_idx ON public.icalendar_event_v1_fixture (calendar_external_id);
CREATE INDEX IF NOT EXISTS svi_fixture_uid_idx ON public.icalendar_event_v1_fixture (uid);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.icalendar_event_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_last_modified_at_idx ON public.icalendar_event_v1_fixture (last_modified_at);
CREATE INDEX IF NOT EXISTS svi_fixture_start_at_idx ON public.icalendar_event_v1_fixture (start_at) WHERE ("start_at" IS NOT NULL);
CREATE INDEX IF NOT EXISTS svi_fixture_end_at_idx ON public.icalendar_event_v1_fixture (end_at) WHERE ("end_at" IS NOT NULL);
CREATE INDEX IF NOT EXISTS svi_fixture_start_date_idx ON public.icalendar_event_v1_fixture (start_date) WHERE ("start_date" IS NOT NULL);
CREATE INDEX IF NOT EXISTS svi_fixture_end_date_idx ON public.icalendar_event_v1_fixture (end_date) WHERE ("end_date" IS NOT NULL);
CREATE INDEX IF NOT EXISTS svi_fixture_recurring_event_id_idx ON public.icalendar_event_v1_fixture (recurring_event_id) WHERE ("recurring_event_id" IS NOT NULL);
CREATE INDEX IF NOT EXISTS svi_fixture_calendar_external_id_start_at_end_at_idx ON public.icalendar_event_v1_fixture (calendar_external_id, start_at, end_at) WHERE (("status" IS DISTINCT FROM 'CANCELLED') AND ("start_at" IS NOT NULL));
CREATE INDEX IF NOT EXISTS svi_fixture_calendar_external_id_start_date_end_date_idx ON public.icalendar_event_v1_fixture (calendar_external_id, start_date, end_date) WHERE (("status" IS DISTINCT FROM 'CANCELLED') AND ("start_date" IS NOT NULL));
```

{% include prevnext.html prev='_integrations/icalendar_calendar_v1.md' prevLabel='icalendar_calendar_v1' next='_integrations/increase_account_number_v1.md' nextLabel='increase_account_number_v1' %}
