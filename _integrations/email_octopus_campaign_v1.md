---
title: Email Octopus Campaign
layout: home
nav_order: 130
---

# Email Octopus Campaign (`email_octopus_campaign_v1`)

Replicate Email Octopus Campaigns into your database.

To get set up, run this code from the [WebhookDB CLI](https://webhookdb.com/terminal):
```
webhookdb integrations create email_octopus_campaign_v1
```

Source documentation for this API: [https://emailoctopus.com/api-documentation](https://emailoctopus.com/api-documentation)

## Features

<dl>
<dt>Depends on</dt>
<dd>To use this replicator, you will need <a href="{% link _integrations/email_octopus_list_v1.md %}">email_octopus_list_v1</a>. You'll be prompted to create it if you haven't.</dd>

<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from Email Octopus Campaigns have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `email_octopus_id` | `text` |  |
| `name` | `text` |  |
| `created_at` | `timestamptz` | ✅ |
| `sent_at` | `timestamptz` | ✅ |
| `status` | `text` |  |
| `from_name` | `text` |  |
| `from_email_address` | `text` |  |
| `subject` | `text` |  |
| `row_updated_at` | `timestamptz` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture email_octopus_campaign_v1`.

```sql
CREATE TABLE public.email_octopus_campaign_v1_fixture (
  pk bigserial PRIMARY KEY,
  email_octopus_id text UNIQUE NOT NULL,
  name text,
  created_at timestamptz,
  sent_at timestamptz,
  status text,
  from_name text,
  from_email_address text,
  subject text,
  row_updated_at timestamptz,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_created_at_idx ON public.email_octopus_campaign_v1_fixture (created_at);
CREATE INDEX IF NOT EXISTS svi_fixture_sent_at_idx ON public.email_octopus_campaign_v1_fixture (sent_at);
```

{% include prevnext.html prev='_integrations/convertkit_tag_v1.md' prevLabel='convertkit_tag_v1' next='_integrations/email_octopus_contact_v1.md' nextLabel='email_octopus_contact_v1' %}
