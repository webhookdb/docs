---
title: NextPax Property Manager
layout: home
nav_order: 500
---

# NextPax Property Manager (`nextpax_property_manager_v1`)

{% include enterprise_integration_list.md %}


Replicate NextPax Property Managers into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create nextpax_property_manager_v1
```

Source documentation for this API: [https://developer.nextpax.app/portal/da/swagger#/](https://developer.nextpax.app/portal/da/swagger#/)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/nextpax_auth_v1.md %}">nextpax_auth_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/nextpax_property_manager_policy_v1.md %}">nextpax_property_manager_policy_v1</a></li>
<li><a href="{% link _integrations/nextpax_property_v1.md %}">nextpax_property_v1</a></li>
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

Tables replicated from NextPax Property Managers have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `nextpax_id` | `text` |  |
| `property_management_system` | `text` |  |
| `row_updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture nextpax_property_manager_v1`.

```sql
CREATE TABLE public.nextpax_property_manager_v1_fixture (
  pk bigserial PRIMARY KEY,
  nextpax_id text UNIQUE NOT NULL,
  property_management_system text,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/nextpax_property_manager_policy_v1.md' prevLabel='nextpax_property_manager_policy_v1' next='_integrations/nextpax_property_policy_v1.md' nextLabel='nextpax_property_policy_v1' %}
