---
title: Valid Identifiers
layout: home
nav_order: 50
---

# Valid DB Identifiers

We've chosen to limit valid database identifiers in cases where we accept user-supplied names.
Any time you provide a database identifier name, like when renaming a table
or create a sync target, the identiier must conform to these rules:

- Begin with an upper or lowercase ASCII letter (`a-zA-z`).
- Contain only upper or lowercase ASCII letters, numbers, underscores, and spaces (`a-zA-Z0-9_ `).

That it, it must match the regular expression `/^[a-zA-Z][a-zA-Z\d_ ]*$/`.
