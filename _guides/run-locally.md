---
title: 
layout: home
parent: Getting started
nav_order: 10
---

## [Proxy webhooks](#proxy-webhooks)

If you also need to subscribe to changes in a 3rd party service,
you can subscribe to receive changes from WebhookDB,
rather than having to set up webhooks in each API you use.
This allows you to have a consistent way to configure and verify webhooks.

You can create a webhook subscription either for a single integration or for an
entire organization:

```
$ webhookdb webhook create --integration=svi_abcdefqwerty
Enter a random secret used to sign and verify webhooks to the given url: webhook_secret123
Enter the URL that WebhookDB should POST webhooks to: https://example.com
All webhooks for this stripe_charge_v1 integration will be sent to https://example.com/
```

```
$ webhookdb webhook create --org=acme_corp
Enter a random secret used to sign and verify webhooks to the given url: webhook_secret123
Enter the URL that WebhookDB should POST webhooks to: https://example.com
All webhooks for all integrations belonging to organization Acme Corp will be sent to https://example.com.
```

Once you have created one or more webhooks, you can use the `webhook list` command to view information about them:

```
$ webhookdb webhook list                     
       ID               URL            ASSOCIATED TYPE              ASSOCIATED ID          
  54ca14e3c55e  https://example.com   service_integration   svi_c1lih496odohq4aftvzii6l4a  
  27a6a8921777  https://example.com   organization          acme_corp           
```

From there, you can test any webhook by using the opaque id that appears in the list:

```
$ webhookdb webhook test 54ca14e3c55e
A test event has been sent to https://example.com.
```

You can also delete webhooks that are no longer needed:

```
$ webhookdb webhook delete 54ca14e3c55e
Events will no longer be sent to https://example.com.
```