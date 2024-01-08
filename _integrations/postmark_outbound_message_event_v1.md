---
title: Postmark Outbound Message Event
layout: home
nav_order: 570
---

# Postmark Outbound Message Event (`postmark_outbound_message_event_v1`)

Replicate Postmark Outbound Message Events into your database.

Docs for this API: [https://postmarkapp.com/developer/webhooks/webhooks-overview](https://postmarkapp.com/developer/webhooks/webhooks-overview)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from Postmark Outbound Message Events have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `event_id` | `uuid` |  |
| `message_id` | `text` | ✅ |
| `timestamp` | `timestamptz` | ✅ |
| `record_type` | `text` | ✅ |
| `tag` | `text` | ✅ |
| `recipient` | `text` | ✅ |
| `changed_at` | `timestamptz` | ✅ |
| `delivered_at` | `timestamptz` | ✅ |
| `received_at` | `timestamptz` | ✅ |
| `bounced_at` | `timestamptz` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture postmark_outbound_message_event_v1`.

```sql
CREATE TABLE public.postmark_outbound_message_event_v1_fixture (
  pk bigserial PRIMARY KEY,
  event_id uuid UNIQUE NOT NULL,
  message_id text,
  timestamp timestamptz,
  record_type text,
  tag text,
  recipient text,
  changed_at timestamptz,
  delivered_at timestamptz,
  received_at timestamptz,
  bounced_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_message_id_idx ON public.postmark_outbound_message_event_v1_fixture (message_id);
CREATE INDEX IF NOT EXISTS svi_fixture_timestamp_idx ON public.postmark_outbound_message_event_v1_fixture (timestamp);
CREATE INDEX IF NOT EXISTS svi_fixture_record_type_idx ON public.postmark_outbound_message_event_v1_fixture (record_type);
CREATE INDEX IF NOT EXISTS svi_fixture_tag_idx ON public.postmark_outbound_message_event_v1_fixture (tag);
CREATE INDEX IF NOT EXISTS svi_fixture_recipient_idx ON public.postmark_outbound_message_event_v1_fixture (recipient);
CREATE INDEX IF NOT EXISTS svi_fixture_changed_at_idx ON public.postmark_outbound_message_event_v1_fixture (changed_at);
CREATE INDEX IF NOT EXISTS svi_fixture_delivered_at_idx ON public.postmark_outbound_message_event_v1_fixture (delivered_at);
CREATE INDEX IF NOT EXISTS svi_fixture_received_at_idx ON public.postmark_outbound_message_event_v1_fixture (received_at);
CREATE INDEX IF NOT EXISTS svi_fixture_bounced_at_idx ON public.postmark_outbound_message_event_v1_fixture (bounced_at);
```

{% include prevnext.html prev='_integrations/postmark_inbound_message_v1.md' prevLabel='postmark_inbound_message_v1' next='_integrations/shopify_customer_v1.md' nextLabel='shopify_customer_v1' %}
