---
title: FAQ
layout: home
nav_order: 250
---

# Frequently Asked Questions

We know that any systems dealing with your data require a huge amount of trust.
We aim to be as open and transparent as possible about how WebhookDB works.
You can, of course, [check out the source](https://github.com/webhookdb/webhookdb),
but we'll try to provide higher-level information here.

## How does WebhookDB work?

WebhookDB is a SaaS or self-hosted service that works closely with any database server
(PostgreSQL or others) to schematize, normalize, and upsert API data in real-time.
We call this pattern [API2SQL]({% link _concepts/api2sql.md %}) and we consider WebhookDB one possible implementation of API2SQL.

- WebhookDB is designed to be self-hosted, though most customers get started on [WebhookDB Cloud]({% link docs/cloud.md %}),
  the hosted SaaS version.
- WebhookDB works with any sort of Postgres (or other) database. It is *not* a managed database provider,
  and does not require you to run your own database or install custom extensions
  (ie, it will work whether you are running a DB on your own hardware or using a truly serverless database).
- WebhookDB is designed to run worry-free. There is extensive structured logging and
  configurable error reporting for when something does go wrong.
  But things usually chug along without any issues. Our extensive unit and integration test suite
  and staging environments ensures there are (almost) never regressions.

## How much does WebhookDB cost?

There are three pricing tiers, explained on the [WebhookDB Pricing Page](https://webhookdb.com/pricing).

Roughly, these are:

- The open source version (you run yourself)
- Usage-based pricing (with a generous free tier) on [WebhookDB Cloud]({% link docs/cloud.md %}).
- Additional advanced integrations for certain verticals with a flat yearly fee
  with an [Enterprise license]({% link docs/enterprise.md %}).

## Why shouldn't I build this myself?

This is a question we get a lot. We ask it ourselves whenever someone tries to sell us any technology!

We could give examples of the hundreds of things you end up needing to think about when
integrating APIs, like processing out-of-order webhooks, backfilling, and verification.

Instead, we'll compare WebhookDB to infrastructure abstraction, using AWS as an example.

Let's say you want to run a script to check the weather every hour,
and send an email to you if it's going to snow.
This alert is of great importance since you're caring for vulnerable loved ones who need to prepare.

This script can run:

- Entirely on your own or rented hardware.
- Using cloud VMs, like EC2 or Digital Ocean
- Using containerized infrastructure, like ECS
- Using serverless systems, like AWS Lambda

The problem of "run some function" is a **commodity problem.**
The vast majority of us are going to opt for the simplest, most reliable option.

This is basically the same thing for WebhookDB. We're the 'AWS Lambda' of API integration.

**Integrating with APIs should be a commodity problem.**
The fact that each one paginates differently, for example, isn't interesting. Why should you have to care?

Reinventing solutions to commodity problems is usually of no value.
Yet *so many* of us have written systems to replicate an API to a database.
Thankfully, WebhookDB now exists, and we can stop reinventing this wheel.

## Isn't sharing database schemas brittle?

This advice is also generally true.
If you expose your database schema, it's a recipe for backwards-compatibility issues with clients.
Instead, services expose data through a versioned API of some sort.

However there's a simple explanation as to why the approach WebhookDB takes is totally fine:
the **schemas we expose are based on the compatibility commitments the APIs themselves are making.**

For example, the Stripe Customer integration is known as `stripe_customer_v1`.
If Stripe made a backwards-incompatible change to their API,
it would no longer be their V1 API, and we'd add a `stripe_customer_v2` integration
which would carry the same compatibility guarantees as their V2 API.

## Who operates WebhookDB?

WebhookDB is open source, available at <https://github.com/webhookdb>.

It was originally built, and is currently operated, by the team at [Lithic Technology](https://lithic.tech)
in Portland, Oregon, USA.
