---
title: Transistor Show
layout: home
nav_order: 810
---

# Transistor Show (`transistor_show_v1`)

Replicate Transistor Shows into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create transistor_show_v1
```

Source documentation for this API: [https://developers.transistor.fm/#Show](https://developers.transistor.fm/#Show)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Transistor Shows have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `transistor_id` | `text` |  |
| `author` | `text` |  |
| `created_at` | `timestamptz` | ✅ |
| `description` | `text` |  |
| `title` | `text` |  |
| `updated_at` | `timestamptz` | ✅ |
| `website` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture transistor_show_v1`.

```sql
CREATE TABLE public.transistor_show_v1_fixture (
  pk bigserial PRIMARY KEY,
  transistor_id text UNIQUE NOT NULL,
  author text,
  created_at timestamptz,
  description text,
  title text,
  updated_at timestamptz,
  website text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.transistor_show_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_updated_at_idx ON public.transistor_show_v1_fixture (updated_at);
```

{% include prevnext.html prev='_integrations/transistor_episode_v1.md' prevLabel='transistor_episode_v1' next='_integrations/twilio_sms_v1.md' nextLabel='twilio_sms_v1' %}
