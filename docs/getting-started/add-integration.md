---
title: Add an integration
layout: home
parent: Getting started
nav_order: 40
---

# Add an integration

The steps here will depend on which service you want to connect with. Essentially,
WebhookDB needs auth information in order to access the given API, but where that
information can be found will vary from service to service. Each service/resource
will take you through the process of setting up its integration. For this example,
we will set up an integration with Stripe Charges.

Let's see what services are available:

```
$ webhookdb services list
convertkit_broadcast_v1
convertkit_subscriber_v1
convertkit_tag_v1
increase_ach_transfer_v1
increase_transaction_v1
shopify_customer_v1
shopify_order_v1
stripe_charge_v1
stripe_customer_v1
transistor_episode_v1
transistor_show_v1
twilio_sms_v1
```

We can then use a service name to create an integration:

```
$ webhookdb integrations create stripe_charge_v1
You are about to start reflecting Stripe Charge info into webhookdb.
We've made an endpoint available for Stripe Charge webhooks:

https://api.webhookdb.com/v1/service_integrations/svi_dd4qg2ax629ab022

From your Stripe Dashboard, go to Developers -> Webhooks -> Add Endpoint.
Use the URL above, and choose all of the Charge events.
Then click Add Endpoint.

The page for the webhook will have a 'Signing Secret' section.
Reveal it, then copy the secret (it will start with `whsec_`).
      
Paste or type your secret here: ***

Great! WebhookDB is now listening for Stripe Charges webhooks.
You can query the database through your organization's Postgres connection string:

postgres://d6ab999a:d652560e@bd421d8d.db.webhookdb.com:5432/673a2eaf

You can also run a query through the CLI:

webhookdb db sql "SELECT * FROM stripe_charges_v1_d50b"

If you want to backfill existing Stripe Charges, we'll need your API key.
Run `webhookdb backfill stripe-charges` to get started.
```

{% include prevnext.html prev="docs/getting-started/join-org.md" next="docs/getting-started/query-data.md" %}
