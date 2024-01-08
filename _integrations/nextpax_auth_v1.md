---
title: NextPax Auth
layout: home
nav_order: 460
---

# NextPax Auth (`nextpax_auth_v1`)

Replicate NextPax Auth into your database.

Docs for this API: [https://developer.nextpax.app/portal/da/swagger#/](https://developer.nextpax.app/portal/da/swagger#/)

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/nextpax_amenity_code_v1.md %}">nextpax_amenity_code_v1</a></li>
<li><a href="{% link _integrations/nextpax_property_manager_v1.md %}">nextpax_property_manager_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from NextPax Auth have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `ignore_id` | `integer` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture nextpax_auth_v1`.

```sql
CREATE TABLE public.nextpax_auth_v1_fixture (
  pk bigserial PRIMARY KEY,
  ignore_id integer UNIQUE NOT NULL,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/nextpax_amenity_code_v1.md' prevLabel='nextpax_amenity_code_v1' next='_integrations/nextpax_calendar_v1.md' nextLabel='nextpax_calendar_v1' %}
