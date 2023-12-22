---
title: AWS Price List
layout: home
nav_order: 20
---

# AWS Price List (`aws_pricing_v1`)

Fetch, parse, and process AWS price list information from the API into a relational, fully searchable table.

Docs for this API: [https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-list-query-api-find-services-products.html](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/price-list-query-api-find-services-products.html)

## Features

<dl>
<dt>Supports Webhooks</dt>
<dd>❌</dd>
<dt>Supports Backfilling</dt>
<dd>✅</dd>

</dl>

## Schema

Tables replicated from AWS Price Lists have this schema.
Note that the data types listed are for Postgres;
when [replicating to other databases]({% link _concepts/replication_databases.md %}),
other data types maybe used.

| Column | Type | Indexed |
| `pk` | `bigint` |  |
| `rate_code` | `text` |  |
| `product_sku` | `text` | ✅ |
| `product_family` | `text` | ✅ |
| `product_attributes` | `jsonb` |  |
| `product_group` | `text` | ✅ |
| `product_location` | `text` | ✅ |
| `product_region` | `text` | ✅ |
| `product_operation` | `text` | ✅ |
| `product_usagetype` | `text` | ✅ |
| `publication_date` | `timestamptz` | ✅ |
| `service_code` | `text` | ✅ |
| `version` | `text` | ✅ |
| `term_type` | `text` |  |
| `term_code` | `text` | ✅ |
| `offer_term_code` | `text` | ✅ |
| `effective_date` | `timestamptz` | ✅ |
| `applies_to` | `text[]` |  |
| `begin_range` | `numeric` |  |
| `description` | `text` |  |
| `end_range` | `numeric` |  |
| `unit` | `text` |  |
| `term_attributes` | `jsonb` |  |
| `price_per_unit_raw` | `jsonb` |  |
| `price_per_unit_amount` | `numeric` |  |
| `price_per_unit_currency` | `text` |  |
| `data`* | `jsonb` |  |

<span class="fs-3">* The `data` column contains the raw payload from the webhook or API.
In many cases there is no canonical form, like if a webhook and API request return
two different versions of the same resource.
In that case we try to keep the most coherent and detailed resource."</span>

## Table definition

This definition can also be generated through `webhookdb fixture aws_pricing_v1`.

```sql
CREATE TABLE public.aws_pricing_v1_fixture (
  pk bigserial PRIMARY KEY,
  rate_code text UNIQUE NOT NULL,
  product_sku text,
  product_family text,
  product_attributes jsonb,
  product_group text,
  product_location text,
  product_region text,
  product_operation text,
  product_usagetype text,
  publication_date timestamptz,
  service_code text,
  version text,
  term_type text,
  term_code text,
  offer_term_code text,
  effective_date timestamptz,
  applies_to text[],
  begin_range numeric,
  description text,
  end_range numeric,
  unit text,
  term_attributes jsonb,
  price_per_unit_raw jsonb,
  price_per_unit_amount numeric,
  price_per_unit_currency text,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS svi_fixture_product_sku_idx ON public.aws_pricing_v1_fixture (product_sku);
CREATE INDEX IF NOT EXISTS svi_fixture_product_family_idx ON public.aws_pricing_v1_fixture (product_family);
CREATE INDEX IF NOT EXISTS svi_fixture_product_group_idx ON public.aws_pricing_v1_fixture (product_group);
CREATE INDEX IF NOT EXISTS svi_fixture_product_location_idx ON public.aws_pricing_v1_fixture (product_location);
CREATE INDEX IF NOT EXISTS svi_fixture_product_region_idx ON public.aws_pricing_v1_fixture (product_region);
CREATE INDEX IF NOT EXISTS svi_fixture_product_operation_idx ON public.aws_pricing_v1_fixture (product_operation);
CREATE INDEX IF NOT EXISTS svi_fixture_product_usagetype_idx ON public.aws_pricing_v1_fixture (product_usagetype);
CREATE INDEX IF NOT EXISTS svi_fixture_publication_date_idx ON public.aws_pricing_v1_fixture (publication_date);
CREATE INDEX IF NOT EXISTS svi_fixture_service_code_idx ON public.aws_pricing_v1_fixture (service_code);
CREATE INDEX IF NOT EXISTS svi_fixture_version_idx ON public.aws_pricing_v1_fixture (version);
CREATE INDEX IF NOT EXISTS svi_fixture_term_code_idx ON public.aws_pricing_v1_fixture (term_code);
CREATE INDEX IF NOT EXISTS svi_fixture_offer_term_code_idx ON public.aws_pricing_v1_fixture (offer_term_code);
CREATE INDEX IF NOT EXISTS svi_fixture_effective_date_idx ON public.aws_pricing_v1_fixture (effective_date);
```

{% include prevnext.html prev='_integrations/atom_single_feed_v1.md' prevLabel='atom_single_feed_v1' next='_integrations/bookingpal_listing_calendar_v1.md' nextLabel='bookingpal_listing_calendar_v1' %}
