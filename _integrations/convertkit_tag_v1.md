---
title: ConvertKit Tag
layout: home
nav_order: 120
---

# ConvertKit Tag (`convertkit_tag_v1`)

Replicate ConvertKit Tags into your database.

Docs for this API: [https://developers.convertkit.com/#list-tags](https://developers.convertkit.com/#list-tags)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from ConvertKit Tags have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `convertkit_id` | `bigint` |  |
| `created_at` | `timestamptz` | ✅ |
| `name` | `text` | ✅ |
| `total_subscriptions` | `integer` |  |
| `enrichment` | `jsonb` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture convertkit_tag_v1`.

```sql
CREATE TABLE public.convertkit_tag_v1_fixture (
  pk bigserial PRIMARY KEY,
  convertkit_id bigint UNIQUE NOT NULL,
  created_at timestamptz,
  name text,
  total_subscriptions integer,
  enrichment jsonb,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.convertkit_tag_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_name_idx ON public.convertkit_tag_v1_fixture (name);
```

{% include prevnext.html prev='_integrations/convertkit_subscriber_v1.md' prevLabel='convertkit_subscriber_v1' next='_integrations/email_octopus_campaign_v1.md' nextLabel='email_octopus_campaign_v1' %}
