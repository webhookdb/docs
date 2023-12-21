---
title: Backfill existing data 
layout: home
parent: Getting started
nav_order: 60
---

# Backfill existing data

WebhookDB will add any new and updated resources to your database,
but cannot access historical data without some privileges.
You can run a command to start a backfill of all the resources available to an integration.
First, list the integrations to find the one to backfill:

```
$ webhookdb integrations list
id               name           table
svi_0d675ecfeb3fb9ed stripe-charges stripe_charges_v1_d50b
```

Then we can kick off a backfill. It will ask for API keys if you have not already added them:

```
$ webhookdb backfill svi_0d675ecfeb3fb9ed
In order to backfill Stripe Charges, we need an API key.
From your Stripe Dashboard, go to Developers -> API Keys -> Restricted Keys -> Create Restricted Key.
Create a key with Read access to Charges.
Submit, then copy the key when Stripe shows it to you:

Paste or type your Restricted Key here: ***

Great! We are going to start backfilling your Stripe Charges.
Stripe allows us to backfill your entire history of charges,
so you're in good shape.

You can query the database through your organization's Postgres connection string:
    
postgres://d6ab999a:d652560e@bd421d8d.db.webhookdb.com:5432/673a2eaf

You can also run a query through the CLI:

webhookdb db sql "SELECT * FROM stripe_charges_v1_d50b"
```

Note that for some integrations, WebhookDB is limited in what it can backfill,
such as the last 90 days of Shopify Orders, for example.
The CLI will let you know when we cannot backfill a full history.

{% include prevnext.html prev="docs/getting-started/query-data.md" next="docs/getting-started/sync.md" %}
