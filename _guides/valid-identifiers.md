---
title: 
layout: home
parent: Getting started
nav_order: 10
---

## [Valid DB Identifiers](#db-identifiers)

We've chosen to limit valid database identifiers in cases where we accept user-supplied names.
Any time you provide a database identifier name, like when renaming a table
or create a sync target, the identiier must conform to these rules:

- Begin with an upper or lowercase ASCII letter (`a-zA-z`).
- Contain only upper or lowercase ASCII letters, numbers, underscores, and spaces (`a-zA-Z0-9_ `).

That it, it must match the regular expression `/^[a-zA-Z][a-zA-Z\d_ ]*$/`.

We understand this may be an issue in some rare cases, such as if WebhookDB needs to integrate
with some existing system. If that's the case,
please email <a href="mailto:hello@webhookdb.com">hello@webhookdb.com</a>
and let us know.
