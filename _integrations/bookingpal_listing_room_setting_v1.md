---
title: BookingPal Listing Room Setting
layout: home
nav_order: 60
---

# BookingPal Listing Room Setting (`bookingpal_listing_room_setting_v1`)

{% include enterprise_integration_list.md %}


Replicate BookingPal Listing Room Settings into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create bookingpal_listing_room_setting_v1
```

Source documentation for this API: [https://www.apimatic.io/apidocs/channelapi/v/2_24](https://www.apimatic.io/apidocs/channelapi/v/2_24)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/bookingpal_root_v1.md %}">bookingpal_root_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>✅</dd>
<dt>Supports Backfilling</dt>
<dd>❌</dd>
<dt>Enterprise Only</dt>
<dd>Yes</dd>

</dl>

## Schema

Tables replicated from BookingPal Listing Room Settings have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `listing_id` | `integer` |  |
| `row_updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture bookingpal_listing_room_setting_v1`.

```sql
CREATE TABLE public.bookingpal_listing_room_setting_v1_fixture (
  pk bigserial PRIMARY KEY,
  listing_id integer UNIQUE NOT NULL,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/bookingpal_listing_policy_v1.md' prevLabel='bookingpal_listing_policy_v1' next='_integrations/bookingpal_listing_status_v1.md' nextLabel='bookingpal_listing_status_v1' %}
