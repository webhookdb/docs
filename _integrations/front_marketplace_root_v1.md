---
title: Front Auth
layout: home
nav_order: 180
---

# Front Auth (`front_marketplace_root_v1`)

You can replicate your data to WebhookDB Cloud using the Front Marketplace.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create front_marketplace_root_v1
```

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/front_conversation_v1.md %}">front_conversation_v1</a></li>
<li><a href="{% link _integrations/front_message_v1.md %}">front_message_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>

</dl>

## Schema

Tables replicated from Front Auth have this schema.
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

This definition can also be generated through `webhookdb fixture front_marketplace_root_v1`.

```sql
CREATE TABLE public.front_marketplace_root_v1_fixture (
  pk bigserial PRIMARY KEY,
  ignore_id integer UNIQUE NOT NULL,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/front_conversation_v1.md' prevLabel='front_conversation_v1' next='_integrations/front_message_v1.md' nextLabel='front_message_v1' %}
