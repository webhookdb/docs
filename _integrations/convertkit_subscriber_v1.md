---
title: ConvertKit Subscriber
layout: home
nav_order: 110
---

# ConvertKit Subscriber (`convertkit_subscriber_v1`)

Replicate ConvertKit subscribers into a database. This is one of the only ways you can keep track of historical subscriber information with ConvertKit.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create convertkit_subscriber_v1
```

Source documentation for this API: [https://developers.convertkit.com/#list-subscribers](https://developers.convertkit.com/#list-subscribers)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from ConvertKit Subscribers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `convertkit_id` | `bigint` |  |
| `canceled_at` | `timestamptz` | ✅ |
| `created_at` | `timestamptz` | ✅ |
| `email_address` | `text` | ✅ |
| `first_name` | `text` |  |
| `last_name` | `text` |  |
| `state` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture convertkit_subscriber_v1`.

```sql
CREATE TABLE public.convertkit_subscriber_v1_fixture (
  pk bigserial PRIMARY KEY,
  convertkit_id bigint UNIQUE NOT NULL,
  canceled_at timestamptz,
  created_at timestamptz,
  email_address text,
  first_name text,
  last_name text,
  state text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_canceled_at_idx ON public.convertkit_subscriber_v1_fixture (canceled_at);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.convertkit_subscriber_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_email_address_idx ON public.convertkit_subscriber_v1_fixture (email_address);
```

{% include prevnext.html prev='_integrations/convertkit_broadcast_v1.md' prevLabel='convertkit_broadcast_v1' next='_integrations/convertkit_tag_v1.md' nextLabel='convertkit_tag_v1' %}
