---
title: Custom Integrations
layout: home
nav_order: 30
---

# Custom Integrations

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

Then, to deploy WebhookDB, you can either:

- Fork the `webhookdb` repo and add your gem to the `Gemfile`, which will build it into the built image.
  This is simpler, and what you'd do if deploying the container, or are already customizing a fork.
- Or, create a repo for deployment, which depends on the `webhookdb` gem and your custom replicators gem.
  This is what you'd do if deploying via Heroku without a container, or you want to avoid a fork.
  We do this for WebhookDB Cloud, which has WebhookDB Enterprise replicators available,
  for instance.

### Notes

**Instead of a private package server,** you can use your gem directly from GitHub:

```ruby
# Gemfile
gem :my_custom_replicators, git: "https://github.com/myorg/my-custom-replicators.git", ref: "main"
```

**To build tests,** you will need to add a couple gems to your Gemfile's test group
that WebhookDB's fixtures and behaviors depend on:

```ruby
# Gemfile
group :test do
  gem "faker"
  gem "fluent_fixtures"
  gem "rspec"
end
```

**To preview emails,** check out the `Makefile`. In fact, for examples of how to do anything relevant, check out the Makefile.
The example repository contains pretty much everything you should need to do for a gem with custom replicators.
