---
title: Custom Integrations
layout: home
nav_order: 30
---

# Custom Integrations
{: .no_toc }

1. TOC
{:toc}

Custom integrations can be developed in one of two ways:

- Adding to the [`webhookdb/replicator`](https://github.com/webhookdb/webhookdb/tree/main/lib/webhookdb/replicator) folder for replicators being contributed upstream.
- Adding to the [`webhookdb/replicator_ext`](https://github.com/webhookdb/webhookdb/tree/main/lib/webhookdb/replicator_ext) folder for in-house (private/proprietary) replicators.
- Distributing replicators as a separate Gem and combining them with a third application.

## Adding new contributable replicators

If you are building a replicator that you plan to contribute back upstream
to WebhookDB, you should add it directly to the [`webhookdb/replicator` folder](https://github.com/webhookdb/webhookdb/tree/gemsupport/lib/webhookdb/replicator),
the same as other replicators.

## Adding new proprietary/private replicators

If you are building a replicator that you do *not* plan to contribute back upstream,
you can add it to the [`webhookdb/replicator_ext` folder](https://github.com/webhookdb/webhookdb/tree/gemsupport/lib/webhookdb/replicator_ext)
on your fork.

This folder exists for the purpose of storing your replicators,
so they will never conflict with any files upstream (this folder will always be empty in the upstream project).

That way, you can fork WebhookDB, build and deploy an image from your fork,
and it will include your own replicators without any additional work.

## Distributing your own replicators

If you have replicators that you want to distribute, you can build them as a Ruby gem.

For example, the WebhookDB Enterprise integrations are deployed as a gem,
since they are reused in WebhookDB Cloud and self-hosted installs.

{: .notice }
See [webhookdb/custom-integrations-demo](https://github.com/webhookdb/custom-integrations-demo)
for an example showing this approach to custom replicators.

Any files in the following folders are loaded automatically from your gem:

- `lib/webhookdb/replicator` (for custom replicators)
- `lib/webhookdb/jobs` (so you can add custom async jobs)
- `lib/webhookdb/messages` (so your replicators or jobs can send custom emails)

Write your code (usually just replicators) and then build a gem for it.

The [webhookdb/custom-integrations-demo repo](https://github.com/webhookdb/custom-integrations-demo)
contains an example gemspec showing one approach to this.

## Deploying WebhookDB with your own replicators

If you have separately distributed replicators, you'll need to put them together with WebhookDB.
There are two ways to do this:

**1) Fork the `webhookdb` repo.** Then add your gem to the `Gemfile`, which will build it into the built image.
This is a much simpler option, because it doesn't require any new repos.
The only downside is it requires you to main a fork.

**2) Create a repo for deployment.** It depends on the `webhookdb` gem,
and any other gems. It also allows more extensive customization about the deployment situation,
without having to worry about maintaining your branch (for example, if you need a custom Docker image,
this can be a good option).

We use the 'separate repo' approach for [WebhookDB Cloud]({% link docs/cloud.md %}),
since it requires the gem containing [enterprise integrations]({% link docs/enterprise.md %}).

{: .notice }
See <https://github.com/webhookdb/custom-deployment-example> for an example/starter deployment repo.
