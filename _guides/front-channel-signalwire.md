---
title: Front/Signalwire Channel
layout: home
nav_order: 1450
---

# Front/SignalWire Channel

Create a WebhookDB/SignalWire SMS channel in Front to manage your SMS messages alongside all your other channels. Instant, two-way sync with SignalWire means that you can send, receive, and reply to SMS messages directly from Front.

<img src="/assets/images/front-signalwire-channel.png" style="width: calc(100% - 1rem); margin-top: 1rem; margin-left: 0.5rem; margin-right: 0.5rem; margin-bottom: 1rem; height: auto;">

This channel only takes a couple minutes to set up:

- Go to <https://webhookdb.com/terminal> and sign up or log in.
  - Run `webhookdb auth login` and follow the prompts.
- Create a Signalwire Message integration, so your SignalWire SMS will sync
  into your WebhookDB replication table.
  - Run `webhookdb integrations create signalwire_message_v1` and follow the prompts.
- Create the Front/SignalWire Channel.
  - Run `webhookdb integrations create front_signalwire_message_channel_app_v1`
    and follow the prompts.
  - You will get an API token at the end (starting with `sk`), which you'll need to input into Front.
- Finally, add the Front Channel.
  - In Front, to to Settings -> Company -> Channels -> Connect a Channel
  - Find the 'WebhookDB/SignalWire' channel, and press Connect
  - For 'Name', use what you like.
  - For 'Token', use the token from the previous step.
  - Finish the channel setup (choose an inbox, etc).

Whenever you send a message via Front, it will be sent via SignalWire within a few seconds.
Whenever an SMS comes in through SignalWire, it will be imported into Front within 60 seconds.

## Changing the SignalWire Phone Number

Run `webhookdb integration reset front_signalwire_message_channel_app_v1`.
You will be prompted for the new phone number.

Note that the last 2 days of inbound messages to this phone number will be automatically synced into Front.

## Rolling the API Key

Run `webhookdb integration roll-key front_signalwire_message_channel_app_v1`.
The old API key will be replaced with a new key.

You must copy the new key and update your Channel settings in Front.

## More information

If you want to replicate your Front data into an SQL database,
you can use our main WebhookDB integration.
Install it [on the Front App Store](https://app.frontapp.com/settings/apps/details/webhookdb/overview).

Check out [our guide]({% link docs/getting-started/index.md %}) to add additional APIs,
and to sync data to your [data warehouse]({% link docs/integrating/dbsync.md %})
or your own [application backend]({% link docs/integrating/httpsync.md %}).
