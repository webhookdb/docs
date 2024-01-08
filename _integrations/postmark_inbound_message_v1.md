---
title: Postmark Inbound Message
layout: home
nav_order: 560
---

# Postmark Inbound Message (`postmark_inbound_message_v1`)

Replicate Postmark Inbound Messages into your database.

Docs for this API: [https://postmarkapp.com/developer/user-guide/inbound/parse-an-email](https://postmarkapp.com/developer/user-guide/inbound/parse-an-email)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from Postmark Inbound Messages have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `message_id` | `text` |  |
| `from_email` | `text` | ✅ |
| `to_email` | `text` | ✅ |
| `subject` | `text` | ✅ |
| `timestamp` | `timestamptz` | ✅ |
| `tag` | `text` | ✅ |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture postmark_inbound_message_v1`.

```sql
CREATE TABLE public.postmark_inbound_message_v1_fixture (
  pk bigserial PRIMARY KEY,
  message_id text UNIQUE NOT NULL,
  from_email text,
  to_email text,
  subject text,
  timestamp timestamptz,
  tag text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_from_email_idx ON public.postmark_inbound_message_v1_fixture (from_email);
CREATE INDEX IF NOT EXISTS svi_fixture_to_email_idx ON public.postmark_inbound_message_v1_fixture (to_email);
CREATE INDEX IF NOT EXISTS svi_fixture_subject_idx ON public.postmark_inbound_message_v1_fixture (subject);
CREATE INDEX IF NOT EXISTS svi_fixture_timestamp_idx ON public.postmark_inbound_message_v1_fixture (timestamp);
CREATE INDEX IF NOT EXISTS svi_fixture_tag_idx ON public.postmark_inbound_message_v1_fixture (tag);
```

{% include prevnext.html prev='_integrations/plivo_sms_inbound_v1.md' prevLabel='plivo_sms_inbound_v1' next='_integrations/postmark_outbound_message_event_v1.md' nextLabel='postmark_outbound_message_event_v1' %}
