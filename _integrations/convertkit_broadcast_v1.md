---
title: ConvertKit Broadcast
layout: home
nav_order: 100
---

# ConvertKit Broadcast (`convertkit_broadcast_v1`)

Replicate ConvertKit Broadcasts into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create convertkit_broadcast_v1
```

Source documentation for this API: [https://developers.convertkit.com/#list-broadcasts](https://developers.convertkit.com/#list-broadcasts)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from ConvertKit Broadcasts have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `convertkit_id` | `bigint` |  |
| `click_rate` | `numeric` |  |
| `created_at` | `timestamptz` | ✅ |
| `open_rate` | `numeric` |  |
| `progress` | `numeric` |  |
| `recipients` | `integer` |  |
| `show_total_clicks` | `boolean` |  |
| `status` | `text` |  |
| `subject` | `text` |  |
| `total_clicks` | `integer` |  |
| `unsubscribes` | `integer` |  |
| `enrichment` | `jsonb` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture convertkit_broadcast_v1`.

```sql
CREATE TABLE public.convertkit_broadcast_v1_fixture (
  pk bigserial PRIMARY KEY,
  convertkit_id bigint UNIQUE NOT NULL,
  click_rate numeric,
  created_at timestamptz,
  open_rate numeric,
  progress numeric,
  recipients integer,
  show_total_clicks boolean,
  status text,
  subject text,
  total_clicks integer,
  unsubscribes integer,
  enrichment jsonb,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.convertkit_broadcast_v1_fixture (created_at);
```

{% include prevnext.html prev='_integrations/bookingpal_root_v1.md' prevLabel='bookingpal_root_v1' next='_integrations/convertkit_subscriber_v1.md' nextLabel='convertkit_subscriber_v1' %}
