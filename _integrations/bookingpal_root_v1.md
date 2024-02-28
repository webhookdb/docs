---
title: BookingPal Root
layout: home
nav_order: 90
---

# BookingPal Root (`bookingpal_root_v1`)

{% include enterprise_integration_list.md %}


This replicator is used to store the authentication secret with BookingPal.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create bookingpal_root_v1
```

## Features

<dl>
<dt>Dependents</dt>
<dd>This replicator is required for the creation of the following dependents:
<ul>
<li><a href="{% link _integrations/bookingpal_listing_calendar_v1.md %}">bookingpal_listing_calendar_v1</a></li>
<li><a href="{% link _integrations/bookingpal_listing_photo_v1.md %}">bookingpal_listing_photo_v1</a></li>
<li><a href="{% link _integrations/bookingpal_listing_policy_v1.md %}">bookingpal_listing_policy_v1</a></li>
<li><a href="{% link _integrations/bookingpal_listing_room_setting_v1.md %}">bookingpal_listing_room_setting_v1</a></li>
<li><a href="{% link _integrations/bookingpal_listing_status_v1.md %}">bookingpal_listing_status_v1</a></li>
<li><a href="{% link _integrations/bookingpal_listing_v1.md %}">bookingpal_listing_v1</a></li>
</ul>
</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from BookingPal Root have this schema.
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

This definition can also be generated through `webhookdb fixture bookingpal_root_v1`.

```sql
CREATE TABLE public.bookingpal_root_v1_fixture (
  pk bigserial PRIMARY KEY,
  ignore_id integer UNIQUE NOT NULL,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/bookingpal_listing_v1.md' prevLabel='bookingpal_listing_v1' next='_integrations/convertkit_broadcast_v1.md' nextLabel='convertkit_broadcast_v1' %}
