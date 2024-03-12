---
title: Increase
layout: home
nav_order: 1250
---

# Increase
{: .no_toc }

1. TOC
{:toc}

Use WebhookDB to sync all your Increase resources into an SQL database using WebhookDB.

We use Increase's [OAuth support](https://increase.com/documentation/oauth) to simplify the user experience
and sync all resources with minimal setup.

## Syncing Increase

To get set up, head to <https://api.webhookdb.com/increase>,
then follow the prompts. You'll be sent to Increase to authorize the WebhookDB application,
then back to WebhookDB to finish setting up your account.

It should take less than a minute to set up. WebhookDB will sync all your existing data,
and keep the database up to date with new data as soon as it is available.

## Self-hosting

If you're self-hosting WebhookDB, you need to set up your own WebhookDB installation as an OAuth app in Increase.
They've made this very simple:

1. Go to <https://dashboard.increase.com/developers/api_keys> and create a new Production API Key.
   Name it "WebhookDB", and copy it down.
2. Create a random string (using `openssl rand -hex 16` or whatever), and copy it down.
   This will be your webhook signing secret.
3. Go to <https://dashboard.increase.com/developers/webhooks> and create a new webhook.
   1. The endpoint should be `<host>/v1/install/increase/webhook`, like `https://api.webhookdb.com/v1/install/increase/webhook`.
   2. Leave 'Selected event category' empty (you want to receive all events).
   3. The signing secret should be the generated string from Step 2.
   4. Save the webhook.
4. Head over to <https://dashboard.increase.com/developers/oauths> and set up a new application.
   1. Name it whatever you want.
   2. For the Redirect URI, use `<host>/v1/install/increase/callback`, like `https://api.webhookdb.com/v1/install/increase/callback`.
   3. Copy down your Client ID and Client Secret.
5. Go to however you configure your WebhookDB environment (AWS Parameter Store or Secrets Manager, Heroku Config Vars, etc.,
   a `.env` file, etc).
6. Set the following environment variables:
   1. Set `INCREASE_API_KEY` to the API key you copied from Step 1.
   2. Set `INCREASE_WEBHOOK_SECRET` to the signing secret from Step 2.
   3. Set `INCREASE_OAUTH_CLIENT_ID` to the OAuth Client ID from Step 4.
   4. Set `INCREASE_OAUTH_CLIENT_SECRET` to the OAuth Client Secret from Step 4.

Start/restart your server. Finally, you can follow the steps above: go to `<host>/increase`
and follow the prompts. Replicators will be created and your data will be automatically synced.

## Next Steps

Once WebhookDB is syncing, you have two options for getting the data back out:

1. Use SQL to query the database. Run `webhookdb db connection` to get your SQL connection string
   and query your Increase tables in your attached WebhookDB database.
2. Use HTTP Sync to get notified about updates.
   This is a powerful-but-simple way to update your own database objects
   whenever changes happen in your attached calendars.
   Check out the [docs on HTTP Sync]({% link docs/integrating/httpsync.md %}).

## Getting Help

If you need any help, we're here to assist. Just email [hello@webhookdb.com](mailto:hello@webhookdb.com)
and we'll get back to you right away.
