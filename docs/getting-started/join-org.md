---
title: Create or join an organization
layout: home
parent: Getting started
nav_order: 30
---

# Create or join an Organization

To set up integrations, you need to be part of an Organization.

**NOTE: You get a default organization when you sign up or have been invited to ,
so you can skip this part if you are just taking things for a spin.**

You can create a new organization:

```
$ webhookdb org create "Acme Corp"
Your organization identifier is: acme_corp
It is now active.
Use `webhookdb org invite` to invite members to Acme Corp.
```

You can invite others to your organization by using the `username` flag to provide their email address:

```
$ webhookdb org invite --username=ashley@webhookdb.com
An invitation has been sent to ashley@webhookdb.com. 
Their invite code is:
  join-f26b81a2
```


If you have an invitation code, you can use it to join that organization:

```
$ webhookdb org join join-568eb975
Congratulations! You are now a member of Acme Corp.
```

List members of an organization:

```
$ webhookdb org members
joe@webhookdb.com (admin)
ashley@webhookdb.com (invited)
```

Remove someone from your organization (invited or an actual member):

```
$ webhookdb org remove ashley@webhookdb.com
ashley@webhookdb.com is no longer a part of the Acme Corp organization.
```

If you are a part of multiple organizations, you can choose which is active:

```
$ webhookdb org list
acmecorp (active)
justiceleague
$ webhookdb org activate justiceleague
Justice League is now your active organization.
```

You can also override the organization for a specific command:

```
$ webhookdb integrations list --org=acmecorp
```

{% include prevnext.html prev="docs/getting-started/auth.md" next="docs/getting-started/add-integration.md" %}
