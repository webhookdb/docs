---
title: Notifications
layout: home
parent: Integrating WebhookDB
nav_order: 40
---

# Notifications

Notifications are used to notify a subscriber (you, or potentially some service like Zapier)
whenever a row is modified in WebhookDB. This can be due to WebhookDB receiving a webhook,
or rows changing during [backfill]({% link _concepts/poll-and-backfill.md %}).

{: .notice }
Yes, what we call 'notifications' are really 'webhooks.'
However, to differentiate between the webhooks that WebhookDB receives,
and the webhooks it sends out, we call the former 'webhooks'
and the latter 'notifications.'

The main benefits of notifications are that:

- Verification is consistent: verify WebhookDB notifications once,
  and you're good to go for all services (you do not need to reimplement webhook verification over and over).
- Delivery is consistent: Our retry and consistency guarantees are clear, so your code does not have to worry about how a 3rd party service behaves.
- Receive notifications during backfill: If a 3rd party API doesn't support webhooks directly, use Notifications to give it that behavior.

You can create a notification subscription either for a single integration or for an entire organization:

```
$ webhookdb notification create --integration=svi_abcdefqwerty
Enter a random secret used to sign and verify notifications to the given url: webhook_secret123
Enter the URL that WebhookDB should POST notifications to: https://example.com
All notifications for this stripe_charge_v1 integration will be sent to https://example.com/
```

```
$ webhookdb notification create --org=acme_corp
Enter a random secret used to sign and verify notifications to the given url: webhook_secret123
Enter the URL that WebhookDB should POST notifications to: https://example.com
All notifications for all integrations belonging to organization Acme Corp will be sent to https://example.com.
```

Once you have created one or more notifications, you can use the `webhookdb notification list` command to view information about them:

```
$ webhookdb notification list                     
       ID               URL            ASSOCIATED TYPE              ASSOCIATED ID          
  54ca14e3c55e  https://example.com   service_integration   svi_c1lih496odohq4aftvzii6l4a  
  27a6a8921777  https://example.com   organization          acme_corp           
```

From there, you can test any notification subscription by using the opaque id that appears in the list:

```
$ webhookdb notification test 54ca14e3c55e
A test event has been sent to https://example.com.
```

You can also delete notification subscriptions that are no longer needed:

```
$ webhookdb notification delete 54ca14e3c55e
Events will no longer be sent to https://example.com.
```

{% include prevnext.html prev="docs/integrating/httpsync.md" next="docs/integrating/saved-queries.md" %}
