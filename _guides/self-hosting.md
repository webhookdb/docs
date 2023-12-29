---
title: Self-Hosting
layout: home
nav_order: 40
---

# Self-Hosted WebhookDB Operations
{: .no_toc }

This is an operational guide to running WebhookDB in any environment.
Since WebhookDB has a flexible "self-hosting" setup (container, standard Ruby app, etc),
it doesn't cover how to run WebhookDB in *your* environment,
but it does cover what WebhookDB needs from an environment in order to run.

1. TOC
{:toc}

## Service Dependencies

- **Postgres**. See [`docker-compose.yml`](https://github.com/webhookdb/webhookdb/blob/main/docker-compose.yml) for the version we run against.
  As specified below, this goes into the `DATABASE_URL` environment variable.
- **Redis**. See [`docker-compose.yml`](https://github.com/webhookdb/webhookdb/blob/main/docker-compose.yml) for the version we run against.
  As explained below, this goes into the `REDIS_URL` environment variable.

## Configuration

There are some important environment variables you'll want to set.
We use [`appydays`](https://github.com/lithictech/appydays) for configuration,
so refer to its documentations on how to find all available environment variables.

- `ASYNC_WEB_PASSWORD` and
- `ASYNC_WEB_USERNAME` are used as the basic auth for the Sidekiq Web UI.
- `DATABASE_URL` the application database URL.
- `DB_BUILDER_ALLOW_PUBLIC_MIGRATIONS` should generally be `true` if this is a private instance.
  It's used to perform migrations of databases tied to organizations.
- `DBUTIL_SLOW_QUERY_SECONDS` can be 0.8 or something high enough.
- `DURABLE_JOB_ENABLED` should be `true` if your instance cannot afford to lose jobs.
  We recommend only setting this when you really need it; if you are mostly using backfill integrations,
  you generally don't need this. It increases the surface area of things that can go wrong.
- `EMAIL_ALLOWLIST` should be `*@yourdomain.com` or `*@mydomain.com *@yourdomain` etc.
  Please don't use `*` so you avoid sending emails to users not from your company.
- `POSTMARK_API_KEY` and
- `POSTMARK_SANDBOX_MODE` to `false` if you are sending emails. If not set, fall back to the included SMTP server.
- `RACK_ENV` to `production`
- `REDIS_URL` to the `redis:` or `rediss:` URL for our primary Redis instance.
- `SENTRY_DSN` if you are using Sentry.
- `SUBSCRIPTION_DISABLE_BILLING` to `true` to allow unlimited 'free' integrations and not try to call Stripe for anything on the billing side.
- `WEBHOOKDB_API_URL` to the public host for your server (ie, `https://api.webhookdb.com`).
- `WEBHOOKDB_APP_URL` usually `https://webhookdb.com`
- `WEBHOOKDB_DB_ENCRYPTION_KEY_0` must be a randomly generated 32-character string. One way to generate it is `openssl rand -base64 24`.
- `WEBHOOKDB_DB_EXTENSION_SCHEMA` should be set to `heroku+ext` if running on Heroku.

Finally, there is an important environment variable to take note of:

- `CUSTOMER_SIGNUP_EMAIL_ALLOWLIST` to `*@yourdomain.com` to allow signups for your email domain.
  You can also set this to something like `nomatch` to disable new signups entirely.
  We *strongly* recommend setting this value so no one you don't intend
  can sign up on your instance. This is doubly important with certain database isolation levels,
  as explained later.
  **Note**: you can still create accounts manually through Ruby/pry,
  and administrators can still invite new members.

## Deployment

We currently have a few deployment options for WebhookDB.
It is easy to add more, just file an issue.

**Remember that you will need a Postgres and Redis instance configured**
as explained earlier in this document.

### Docker Container

#### Official Docker Container

Use the official WebhookDB docker image: [`webhookdb/webhookdb`](https://hub.docker.com/r/webhookdb/webhookdb)

#### Build your own Docker Container

You can use `make docker-build` to build a Docker container.
You will need to tag and upload this container yourself,
since it is for all means and purposes your own container.

Usually you'll need to build your own image if you have custom Gems or integrations to include,
like [WebhookDB Enterprise]({% link docs/enterprise.md %}). 

#### Running the Container

The container entrypoints supports some particular commands.
We'll use `docker run` for these examples,
but you may need to use whatever is appropriate for your environment.

- `docker run -p ${PORT}:${PORT} -it webhookdb/webhookdb:latest web` starts the Rack web service.
- `docker run -it webhookdb/webhookdb:latest worker` starts Sidekiq background jobs.
- `docker run -it webhookdb/webhookdb:latest release` runs migrations.
  It should be run once for each deployment/release.
- Otherwise, arguments are passed through directly to the container.
  For example, `docker run -it webhookdb/webhookdb:latest bundle exec rake admin:role[myorg:beta]`
  would run a Rake task.

Note there is a [`bin`](https://github.com/webhookdb/webhookdb/blob/main/bin/docker-run-dev) script for running the container with local environment variables,
which can be invoked like `bin/docker-run-dev web`.

### Heroku

The `webhookdb` repo includes a [`Procfile`](https://github.com/lithictech/webhookdb-api/blob/main/Procfile) and should be recognized as a Ruby project,
so Heroku should work out of the box.

## Logging

WebhookDB is a 12-factor app so logging is done to stdout.
We use structured logging, so you can read the logs as JSON.
If you absolutely need custom log output,
like directly to a particular service or file, file an issue in GitHub.

## Error Handling

If `SENTRY_DSN` is set, we report errors to Sentry.

We also send all errors to the log.
If you aren't using Sentry, you can alert on `error` level logs.

## Monitoring

### Endpoints

Health endpoints are at:

- `/statusz`
- `/healthz`

### Sidekiq

Other than monitoring for errors (via Sentry or logs),
the only other issue is the health of the Sidekiq queue.

The Sidekiq Web UI can be reached at the `/sidekiq` path,
for example at `https://api.webhookdb.com/sidekiq`,
Basic auth is used, with the values of the environment variables `ASYNC_WEB_USERNAME` and `ASYNC_WEB_PASSWORD`.

You can open the Web UI in a browser using:

    Webhookdb::Async.open_web

## External Services

We use a few external services for the app itself (ie not for integrations):

- Sentry for error handling, as explained above.
- Postmark for email. It is not hard to add additional email providers as needed if you use something like Amazon SES, just file an issue.
  If Postmark is not configured, emails will be sent via the included SMTP server.

### SnowflakeDB

If you are using Snowflake as a [DB Sync]({% link docs/integrating/dbsync.md %}) sync target,
you must provide some additional configuration information, and make the `snowsql` binary available for use (we do not use a normal DB driver for it).

If you are using Heroku, you should:

- Use the [Snowflake Snowsql Buildpack](https://github.com/lithictech/heroku-buildpack-snowflake-snowsql)
- Set `SNOWSQL_BUILDPACK_CONFIG_CONTENTS` to `[options]\nlog_file = /tmp/snowsql_log` (the string should be multiline, not contain a `\n`).

If you are using Linux, you can refer to the [`.github/pr-checks.yml`](https://github.com/lithictech/webhookdb-api/blob/main/.github/pr-checks.yml) file for how we install Snowflake on Ubuntu and make it available for unit tests. The script is something like:

```bash
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.21-linux_x86_64.bash
SNOWSQL_DEST=$HOME/snowflake SNOWSQL_LOGIN_SHELL=$HOME/.profile bash snowsql-1.2.21-linux_x86_64.bash
$HOME/snowflake/snowsql -v
echo "$HOME/snowflake" >> PATH
```

MacOS instructions are in the `Makefile`.

## Database Server Considerations

WebhookDB works across multiple databases- namely, there is the 'application database' where things like customers and integration secrets are stored; and 'organization databases' where the per-organization replicated data is stored.

In the 'full' WebhookDB, we have several database servers that we administer. See the README for more details. To make WebhookDB easy to run for clients, however, we support extremely simple stripped down infrastructure models. We present the most common ones here; if none of these fit, let's discuss how to handle your setup.

**If you are running your own server**, like in Amazon RDS, set the environment variable `DATABASE_URL` to a user that can create users and databases, and set `DB_BUILDER_ISOLATION_MODE=database+user`. This will cause each organization to have its own database. All databases will be created on the same server as where  `DATABASE_URL` resides.

**If you are running your own server but `DATABASE_URL` cannot be a superuser** (or one able to create databases and users), set `DB_BUILDER_SERVER_URLS=<superuser url>` and `DB_BUILDER_ISOLATION_MODE=database+user`.

**If you are using hosted databases (Heroku, Render, etc)**, set `DB_BUILDER_ISOLATION_MODE=schema`. This will turn off the automatic database management and will instead merely create a new schema in the `DATABASE_URL` database. If you want to separate the application and organization databases, you can provision a second hosted database and set `DB_BUILDER_SERVER_URLS=<second hosted db url>`. Finally, note you will need to set `WEBHOOKDB_DB_EXTENSION_SCHEMA=heroku_ext` if you are using Heroku.
**IMPORTANT:** When using `schema` isolation, you should set `CUSTOMER_EMAIL_ALLOWLIST` so no one unexpected is able to sign up.
Due to `schema` isolation, it would cause their data to exist in your database!

## Using the CLI against your instance

By default, the WebhookDB CLI connects to `https://api.webhookdb.com`. You have two options for using the CLI against your own server:

- Set `WEBHOOKDB_API_HOST` to your server, like `https://webhookdb.awesomeproduct.xyz`. All `webhookdb` CLI commands will work against that server.
- Use the CLI served from the web server, by going to a URL like `https://webhookdb.awesomeproduct.xyz/terminal`.
  Our CLI is compiled as WASM so it can be served; the CLI served by `/terminal` will be configured to point at the server hosting it.

## Moving data to sit in your application database

WebhookDB automatically provisions databases or schemas for organizations.
Oftentimes, users will set up WebhookDB itself on a small Postgres instance,
but want large amounts of production API data replicated into a different database (this is a form of [Bring Your Own Database](docs/operating-webhookdb/byodb.md)).

You can migrate an organization's data from one database to another using [`webhookdb db migrations`]({% link _manual/migration.md %}).

## New Deployment Checklist

- [ ] Provision a new Postgres instance.
- [ ] Provision a new Redis instance.
- [ ] Set up config as explained above.
- [ ] First deploy of app.
- [ ] Health check at `/healthz`
- [ ] Add `export WEBHOOKDB_API_HOST=https://webhookdb.myapp.com` to your `.bash_profile` or whatever, so you get the right WebhookDB server from the CLI.
- [ ] Create a new user using the CLI (`webhookdb auth login`)
- [ ] Create the 'production' org from the CLI (`webhookdb org create`)
- [ ] Connect to a shell against production.
  - If you are on Heroku, you can use `MERGE_HEROKU_ENV=webhookdb-api-mybusiness bundle exec rake <task>` to run local code against production, OR you can use `heroku run bash --app=webhookdb-api-mybusiness`.
  - [ ] Run `bundle exec rake admin:roles[myorgkey:customintegration]` to add custom roles to your organization, if you are using special integrations.
  - [ ] Run a `bundle exec rake bootstrap` task, if your deployment needs it, like to create all of a certain type of replicator.
    You will get special handover instructions when this is the case.
