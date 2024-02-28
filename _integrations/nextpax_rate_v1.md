---
title: NextPax Rate
layout: home
nav_order: 530
---

# NextPax Rate (`nextpax_rate_v1`)

{% include enterprise_integration_list.md %}


Replicate NextPax Rates into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create nextpax_rate_v1
```

Source documentation for this API: [https://developer.nextpax.app/portal/da/swagger#/](https://developer.nextpax.app/portal/da/swagger#/)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/nextpax_property_v1.md %}">nextpax_property_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from NextPax Rates have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `nextpax_property_id` | `integer` |  |
| `property_manager` | `text` | ✅ |
| `row_updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture nextpax_rate_v1`.

```sql
CREATE TABLE public.nextpax_rate_v1_fixture (
  pk bigserial PRIMARY KEY,
  nextpax_property_id integer UNIQUE NOT NULL,
  property_manager text,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_property_manager_idx ON public.nextpax_rate_v1_fixture (property_manager);
```

{% include prevnext.html prev='_integrations/nextpax_property_v1.md' prevLabel='nextpax_property_v1' next='_integrations/plaid_item_v1.md' nextLabel='plaid_item_v1' %}
