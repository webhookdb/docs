---
title: Run Locally
layout: home
parent: Operating WebhookDB
nav_order: 50
---

# Running WebhookDB Locally

{: .notice }
This guide is about running WebhookDB locally as a user, for the purposes of experimentation,
or as a service dependency of your application during local development.
<br />
<br />
If you are interested in running WebhookDB as a developer (that is, you're working on the WebhookDB code),
refer to the [`README.md`](https://github.com/lithictech/webhookdb-api/blob/main/README.md) and [`Makefile`](https://github.com/lithictech/webhookdb-api/blob/main/Makefile).

You can run with the official WebhookDB docker image [`webhookdb/webhookdb`](https://hub.docker.com/r/webhookdb/webhookdb).

Then you can set up this Docker Compose file:

```yaml
# TODO
```

Then use `docker compose up` and WebhookDB should be working. Go to [http://localhost:18003/terminal](http://localhost:18003/terminal)
and follow along with the [Getting Started guide]({% link docs/getting-started/index.md %}).

## Without Docker Compose

If you want to run without Compose, there's some additional setup:

- You need a Postgres and Redis instance available.
- You need to run web and worker processes.
- You need to migrate the database.

For all commands, you need to pass something like
`--env DATABASE_URL=postgres://dev:dev@localhost:5432/mydb` so the container can find Postgres,
and `--env REDIS_URL=redis://localhost:18007/0` so the container can find Redis.

The relevant commands are:

- `docker run -it webhookdb/webhookdb:latest release` runs migrations.
  You need to run it to get the initial database set up.
- `docker run -it webhookdb/webhookdb:latest web` starts the Rack web service.
  - WebhookDB runs on port 18003 by default. You can set the `PORT` env var, like `--env PORT=1234`,
    or port mapping, like `-p 1234:18003`, to have the container use a different port.
- `docker run -it webhookdb/webhookdb:latest worker` starts Sidekiq background jobs.
- Otherwise, arguments are passed through directly to the container.
  For example, `docker run -it webhookdb/webhookdb:latest bundle exec rake admin:role[myorg:beta]`
  would run a Rake task.

{% include prevnext.html prev="docs/operating-webhookdb/self-hosting.md" next="docs/operating-webhookdb/high-availability.md" %}
