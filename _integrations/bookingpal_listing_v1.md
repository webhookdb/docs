---
title: BookingPal Listing
layout: home
nav_order: 80
---

# BookingPal Listing (`bookingpal_listing_v1`)

Replicate BookingPal Listings into your database.

Docs for this API: [https://www.apimatic.io/apidocs/channelapi/v/2_24](https://www.apimatic.io/apidocs/channelapi/v/2_24)

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

Tables replicated from BookingPal Listings have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `listing_id` | `integer` |  |
| `name` | `text` |  |
| `apt` | `text` |  |
| `street` | `text` |  |
| `city` | `text` |  |
| `country_code` | `text` |  |
| `pm_name` | `text` |  |
| `pm_id` | `integer` |  |
| `row_updated_at` | `timestamptz` |  |
| `deleted_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture bookingpal_listing_v1`.

```sql
CREATE TABLE public.bookingpal_listing_v1_fixture (
  pk bigserial PRIMARY KEY,
  listing_id integer UNIQUE NOT NULL,
  name text,
  apt text,
  street text,
  city text,
  country_code text,
  pm_name text,
  pm_id integer,
  row_updated_at timestamptz,
  deleted_at timestamptz,
  data jsonb NOT NULL
);
```

{% include prevnext.html prev='_integrations/bookingpal_listing_status_v1.md' prevLabel='bookingpal_listing_status_v1' next='_integrations/bookingpal_root_v1.md' nextLabel='bookingpal_root_v1' %}
