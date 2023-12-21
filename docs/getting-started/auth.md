---
title: Auth with WebhookDB
layout: home
parent: Getting started
nav_order: 20
---

# Create or login to your WebhookDB account

WebhookDB uses one-time passwords for authentication. Every time you log in, you'll be asked
to provide an email. WebhookDB will then send a one-time password to
that email. To use the OTP, simply enter it in the terminal when prompted. You can also include it with the `token` flag and  
the `username` flag in a separate `auth login` command.

```
$ Welcome to WebhookDB!
Please enter your email:

joe@lithic.tech

Welcome back!

To finish logging in, please look for an email we just sent to natalie@lithic.tech.
It contains a One Time Password used to log in.
You can enter it here, or if you want to finish up from a new prompt, use:

  webhookdb auth login --username=joe@lithic.tech --token=<6 digit token>

Enter the token from your email:

***

Welcome! For help getting started, please check out
our docs at https://webhookdb.com/docs/guide.
```

You can also log out:

```
$ webhookdb auth logout
You have logged out. 
```

{% include prevnext.html prev="docs/getting-started/install-cli.md" next="docs/getting-started/join-org.md" %}
