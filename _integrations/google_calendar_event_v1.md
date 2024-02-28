---
title: Google Calendar Event
layout: home
nav_order: 260
---

# Google Calendar Event (`google_calendar_event_v1`)

{% include enterprise_integration_list.md %}


Replicate Google Calendar events into your database. This integration expands recurring events. See google_calendar_source_event_v1 for non-expanded events.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create google_calendar_event_v1
```

Source documentation for this API: [https://developers.google.com/calendar/api/v3/reference/events](https://developers.google.com/calendar/api/v3/reference/events)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/google_calendar_v1.md %}">google_calendar_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from Google Calendar Events have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `compound_identity` | `text` | ✅ |
| `external_owner_id` | `text` | ✅ |
| `google_id` | `text` | ✅ |
| `google_calendar_id` | `text` | ✅ |
| `status` | `text` |  |
| `row_created_at` | `timestamptz` |  |
| `row_updated_at` | `timestamptz` | ✅ |
| `created` | `timestamptz` |  |
| `updated` | `timestamptz` |  |
| `start_date` | `date` |  |
| `end_date` | `date` |  |
| `original_start_date` | `date` |  |
| `start_at` | `timestamptz` |  |
| `end_at` | `timestamptz` |  |
| `original_start_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture google_calendar_event_v1`.

```sql
CREATE TABLE public.google_calendar_event_v1_fixture (
  pk bigserial PRIMARY KEY,
  compound_identity text UNIQUE NOT NULL,
  external_owner_id text,
  google_id text,
  google_calendar_id text,
  status text,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  created timestamptz,
  updated timestamptz,
  start_date date,
  end_date date,
  original_start_date date,
  start_at timestamptz,
  end_at timestamptz,
  original_start_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_compound_identity_idx ON public.google_calendar_event_v1_fixture (compound_identity);
CREATE INDEX IF NOT EXISTS svi_fixture_external_owner_id_idx ON public.google_calendar_event_v1_fixture (external_owner_id);
CREATE INDEX IF NOT EXISTS svi_fixture_google_id_idx ON public.google_calendar_event_v1_fixture (google_id);
CREATE INDEX IF NOT EXISTS svi_fixture_google_calendar_id_idx ON public.google_calendar_event_v1_fixture (google_calendar_id);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.google_calendar_event_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_b608e6f9840635a044bcb3973a6b3608_idx ON public.google_calendar_event_v1_fixture (external_owner_id, google_calendar_id, start_at, end_at) WHERE (("status" IS DISTINCT FROM 'cancelled') AND ("start_at" IS NOT NULL));
CREATE INDEX IF NOT EXISTS svi_fixture_421c6a622b9cb00eae0463b7301125a4_idx ON public.google_calendar_event_v1_fixture (external_owner_id, google_calendar_id, start_date, end_date) WHERE (("status" IS DISTINCT FROM 'cancelled') AND ("start_date" IS NOT NULL));
```

{% include prevnext.html prev='_integrations/github_repository_event_v1.md' prevLabel='github_repository_event_v1' next='_integrations/google_calendar_list_v1.md' nextLabel='google_calendar_list_v1' %}
