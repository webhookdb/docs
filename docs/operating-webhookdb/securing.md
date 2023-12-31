---
title: Securing Your Database
layout: home
nav_order: 65
parent: Operating WebhookDB
---

# Securing Your Database

{: .self-hosting }
This article only applies to WebhookDB [self-hosting]({% link docs/operating-webhookdb/self-hosting.md %})
and [bring-your-own-database]({% link docs/operating-webhookdb/byodb.md %}).
When using [WebookDB Cloud](https://webhookdb.com),
you get a readonly database connection string that you can treat
like any other application secret.

One of the exciting features of [API2SQL]({% link _concepts/api2sql.md %})
is that, rather than have to design and implement redundant features like scoped tokens,
you can use the security capabilities of your database. Similar to how API2SQL allows arbitrary querying
of replicated API data, API2SQL allows arbitrary security mechanisms to be placed on top of it too.

## Read-only users

When self-hosting replicated data, you can create your own scoped, read-only database users
that can be shared with clients.

For example, let's say we have an organization with a single integration:

```
$ webhookdb db connection
postgres://aro5a7bca56dae1e774ac:a5a901a18fd3aa56b3a@db.mycompany.com:5432/adb16a635253766ba75617
$ webhookdb integrations list
id                   name               table
svi_0d675ecfeb3fb9ed stripe_charge_v1   stripe_charge_v1_d50b
svi_c1lih496odohq4af stripe_customer_v1 stripe_customer_v1_fa4d
```

Let's say you want a service to be able to access Stripe Charges,
but not Customers.

Log in as an admin of the database server, and run the following:

```sql
CREATE ROLE chargeuser PASSWORD 'abc123' NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
REVOKE ALL ON SCHEMA public FROM chargeuser;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM chargeuser;
GRANT CONNECT ON DATABASE adb16a635253766ba75617 TO chargeuser;
GRANT USAGE ON SCHEMA public TO chargeuser;
GRANT SELECT ON stripe_charge_v1_d50b TO chargeuser;
```

Then you can log in with the new user and confirm you have limited access:

```
$ psql postgres://chargeuser:abc123@db.mycompany.com:5432/adb16a635253766ba75617

adb16a635253766ba75617> select count(1) from stripe_charge_v1_d50b;
0

adb16a635253766ba75617> select count(1) from stripe_customer_v1_fa4d;
permission denied for table stripe_customer_v1_fa4d
```

## Row-level security

Continuing from the above example, perhaps we want to allow a client to see Stripe charges from the last 14 days,
but no older. We can do this with [Row Level Security](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
in Postgres.

```sql
ALTER TABLE stripe_charge_v1_d50b ENABLE ROW LEVEL SECURITY;

CREATE POLICY stripe_charge_view_recent ON stripe_charge_v1_d50b
    FOR SELECT
    USING (created > now() - '14 days'::interval);

CREATE ROLE recent_viewer PASSWORD 'abc123' LOGIN;
GRANT CONNECT ON DATABASE adb16a635253766ba75617 TO recent_viewer;
GRANT USAGE ON SCHEMA public TO recent_viewer;
GRANT SELECT ON stripe_charge_v1_d50b TO recent_viewer;
```

If we connect to the database as an admin, we'll see all charges:

```
$ pgcli postgres://admin:securepassword@db.mycompany.com:5432/adb16a635253766ba75617
adb16a635253766ba75617> select current_date, stripe_id, created from stripe_charge_v1_d50b;
+--------------+------------+-------------------------------+
| current_date | stripe_id  | created                       |
|--------------+------------+-------------------------------|
| 2023-12-23   | old-charge | 2023-11-23 06:48:55.220327+00 |
| 2023-12-23   | new-charge | 2023-12-18 06:48:56.422224+00 |
+--------------+------------+-------------------------------+
```

But if we connect as a normal user (or any user constrained by the row-level security policy),
we'll see only the newer charges:

```
$ $ pgcli postgres://recent_viewer:abc123@db.mycompany.com:5432/adb16a635253766ba75617
adb16a635253766ba75617> select current_date, stripe_id, created from stripe_charge_v1_d50b;
+--------------+------------+-------------------------------+
| current_date | stripe_id  | created                       |
|--------------+------------+-------------------------------|
| 2023-12-23   | new-charge | 2023-12-18 06:48:56.422224+00 |
+--------------+------------+-------------------------------+
```

Note that this level of control is impossible to achieve in most APIs,
but you get it "for free" with WebhookDB and SQL.

{% include prevnext.html prev="docs/operating-webhookdb/autoscaling.md" %}
