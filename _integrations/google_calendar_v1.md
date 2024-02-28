---
title: Google Calendar
layout: home
nav_order: 290
---

# Google Calendar (`google_calendar_v1`)

{% include enterprise_integration_list.md %}


Replicate Google Calendars into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create google_calendar_v1
```

Source documentation for this API: [https://developers.google.com/calendar/api/v3/reference/calendars](https://developers.google.com/calendar/api/v3/reference/calendars)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/google_calendar_list_v1.md %}">google_calendar_list_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/google_calendar_event_v1.md %}">google_calendar_event_v1</a></li>
<li><a href="{% link _integrations/google_calendar_source_event_v1.md %}">google_calendar_source_event_v1</a></li>
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

Tables replicated from Google Calendars have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `compound_identity` | `text` | ✅ |
| `row_created_at` | `timestamptz` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `google_id` | `text` | ✅ |
| `external_owner_id` | `text` | ✅ |
| `time_zone` | `text` |  |
| `deleted` | `boolean` |  |
| `sync_tokens` | `jsonb` |  |
| `events_watch_channel_id` | `text` | ✅ |
| `events_watch_resource_id` | `text` |  |
| `events_watch_channel_expiration` | `timestamptz` | ✅ |
| `events_page_size` | `integer` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture google_calendar_v1`.

```sql
CREATE TABLE public.google_calendar_v1_fixture (
  pk bigserial PRIMARY KEY,
  compound_identity text UNIQUE NOT NULL,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  google_id text,
  external_owner_id text,
  time_zone text,
  deleted boolean,
  sync_tokens jsonb,
  events_watch_channel_id text,
  events_watch_resource_id text,
  events_watch_channel_expiration timestamptz,
  events_page_size integer,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_compound_identity_idx ON public.google_calendar_v1_fixture (compound_identity);
CREATE INDEX IF NOT EXISTS svi_fixture_row_created_at_idx ON public.google_calendar_v1_fixture (row_created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.google_calendar_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_google_id_idx ON public.google_calendar_v1_fixture (google_id);
CREATE INDEX IF NOT EXISTS svi_fixture_external_owner_id_idx ON public.google_calendar_v1_fixture (external_owner_id);
CREATE INDEX IF NOT EXISTS svi_fixture_events_watch_channel_id_idx ON public.google_calendar_v1_fixture (events_watch_channel_id);
CREATE INDEX IF NOT EXISTS svi_fixture_events_watch_channel_expiration_idx ON public.google_calendar_v1_fixture (events_watch_channel_expiration);
```

{% include prevnext.html prev='_integrations/google_calendar_source_event_v1.md' prevLabel='google_calendar_source_event_v1' next='_integrations/icalendar_calendar_v1.md' nextLabel='icalendar_calendar_v1' %}
