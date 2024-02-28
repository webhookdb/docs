---
title: Outlook Calendar Event
layout: home
nav_order: 430
---

# Outlook Calendar Event (`microsoft_calendar_event_v1`)

{% include enterprise_integration_list.md %}


Replicate Outlook Calendar Events into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create microsoft_calendar_event_v1
```

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/microsoft_calendar_v1.md %}">microsoft_calendar_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from Outlook Calendar Events have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `microsoft_event_id` | `text` |  |
| `microsoft_calendar_id` | `text` |  |
| `microsoft_user_id` | `text` |  |
| `row_created_at` | `timestamptz` |  |
| `row_updated_at` | `timestamptz` | ✅ |
| `created` | `timestamptz` |  |
| `updated` | `timestamptz` |  |
| `is_all_day` | `boolean` |  |
| `start_at` | `timestamptz` | ✅ |
| `start_timezone` | `text` |  |
| `original_start_timezone` | `text` |  |
| `end_at` | `timestamptz` | ✅ |
| `end_timezone` | `text` |  |
| `original_end_timezone` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture microsoft_calendar_event_v1`.

```sql
CREATE TABLE public.microsoft_calendar_event_v1_fixture (
  pk bigserial PRIMARY KEY,
  microsoft_event_id text UNIQUE NOT NULL,
  microsoft_calendar_id text,
  microsoft_user_id text,
  row_created_at timestamptz,
  row_updated_at timestamptz,
  created timestamptz,
  updated timestamptz,
  is_all_day boolean,
  start_at timestamptz,
  start_timezone text,
  original_start_timezone text,
  end_at timestamptz,
  end_timezone text,
  original_end_timezone text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.microsoft_calendar_event_v1_fixture (row_updated_at);
CREATE INDEX IF NOT EXISTS svi_fixture_start_at_idx ON public.microsoft_calendar_event_v1_fixture (start_at);
CREATE INDEX IF NOT EXISTS svi_fixture_end_at_idx ON public.microsoft_calendar_event_v1_fixture (end_at);
```

{% include prevnext.html prev='_integrations/intercom_marketplace_root_v1.md' prevLabel='intercom_marketplace_root_v1' next='_integrations/microsoft_calendar_user_v1.md' nextLabel='microsoft_calendar_user_v1' %}
