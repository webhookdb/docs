---
title: Front/SignalWire Message
layout: home
nav_order: 200
---

# Front/SignalWire Message (`front_signalwire_message_channel_app_v1`)

Replicate Front/SignalWire Messages into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create front_signalwire_message_channel_app_v1
```

Source documentation for this API: [https://dev.frontapp.com/docs/getting-started-with-partner-channels](https://dev.frontapp.com/docs/getting-started-with-partner-channels)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/signalwire_message_v1.md %}">signalwire_message_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Front/SignalWire Messages have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `external_id` | `text` |  |
| `signalwire_sid` | `text` | ✅ |
| `front_message_id` | `text` | ✅ |
| `external_conversation_id` | `text` | ✅ |
| `row_updated_at` | `timestamptz` | ✅ |
| `direction` | `text` |  |
| `body` | `text` |  |
| `sender` | `text` |  |
| `recipient` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture front_signalwire_message_channel_app_v1`.

```sql
CREATE TABLE public.front_signalwire_message_channel_app_v1_fixture (
  pk bigserial PRIMARY KEY,
  external_id text UNIQUE NOT NULL,
  signalwire_sid text,
  front_message_id text,
  external_conversation_id text,
  row_updated_at timestamptz,
  direction text,
  body text,
  sender text,
  recipient text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_signalwire_sid_idx ON public.front_signalwire_message_channel_app_v1_fixture (signalwire_sid);
CREATE INDEX IF NOT EXISTS svi_fixture_front_message_id_idx ON public.front_signalwire_message_channel_app_v1_fixture (front_message_id);
CREATE INDEX IF NOT EXISTS svi_fixture_external_conversation_id_idx ON public.front_signalwire_message_channel_app_v1_fixture (external_conversation_id);
CREATE INDEX IF NOT EXISTS svi_fixture_row_updated_at_idx ON public.front_signalwire_message_channel_app_v1_fixture (row_updated_at);
```

{% include prevnext.html prev='_integrations/front_message_v1.md' prevLabel='front_message_v1' next='_integrations/github_issue_comment_v1.md' nextLabel='github_issue_comment_v1' %}
