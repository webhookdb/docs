---
title: Unit testing with WebhookDB 
layout: home
parent: Getting started
nav_order: 90
---

# Unit Testing with WebhookDB

There are two parts to integrating WebhookDB into your unit testing workflow:
creating the schema, and fixturing data.

## Schemas

To get the schema of a WebhookDB table, you can run:

```
webhookdb fixtures stripe_charge_v1
```

This will return the SQL query you can use to build this table:

```sql
CREATE TABLE stripe_charge_v1_fixture (
  pk bigserial PRIMARY KEY,
  "stripe_id" text UNIQUE NOT NULL,
  "amount" numeric ,
  "balance_transaction" text ,
  "billing_email" text ,
  "created" integer ,
  "customer_id" text ,
  "invoice_id" text ,
  "payment_type" text ,
  "receipt_email" text ,
  "status" text ,
  "updated" integer ,
  data jsonb NOT NULL
);
CREATE INDEX IF NOT EXISTS amount_idx ON stripe_charge_v1_fixture ("amount");
CREATE INDEX IF NOT EXISTS balance_transaction_idx ON stripe_charge_v1_fixture ("balance_transaction");
CREATE INDEX IF NOT EXISTS billing_email_idx ON stripe_charge_v1_fixture ("billing_email");
CREATE INDEX IF NOT EXISTS created_idx ON stripe_charge_v1_fixture ("created");
CREATE INDEX IF NOT EXISTS customer_id_idx ON stripe_charge_v1_fixture ("customer_id");
CREATE INDEX IF NOT EXISTS invoice_id_idx ON stripe_charge_v1_fixture ("invoice_id");
CREATE INDEX IF NOT EXISTS payment_type_idx ON stripe_charge_v1_fixture ("payment_type");
CREATE INDEX IF NOT EXISTS receipt_email_idx ON stripe_charge_v1_fixture ("receipt_email");
CREATE INDEX IF NOT EXISTS status_idx ON stripe_charge_v1_fixture ("status");
CREATE INDEX IF NOT EXISTS updated_idx ON stripe_charge_v1_fixture ("updated");
```

Store this SQL as a migration, however you work with migrations.

{: .notice }
Migration systems are hugely varied, so these instructions will need to be adjusted to your application and workflow.

You'll create these tables as part of your testing database schema. 
You won't use these tables in production (you'll use the tables WebhookDB manages and migrates for you).

```
$ touch migrations/webhookdb.sql
$ webhookdb fixtures stripe_charge_v1 >> migrations/webhookdb.sql
$ webhookdb fixtures stripe_customer_v1 >> migrations/webhookdb.sql
```

For example, if you use a separate database when running tests,
you can create these when migrating your test database:

```makefile
migrate:
	DATABASE_URL=postgres://dev:dev@localhost:5432/dev rake db:migrate
migrate-test:
	DATABASE_URL=postgres://dev:dev@localhost:5432/dev_test rake db:migrate
	psql postgres://dev:dev@localhost:5432/dev_test -f migrations/webhookdb.sql  
```

Or if you are using Django, you can conditionally create the tables in your migration file:

```python
operations = []

# Where settings.py has a line like:
# TESTING = len(sys.argv) > 1 and sys.argv[1] == 'test'
if settings.TESTING:
    with open('migrations/webhookdb.sql') as f:
        whdb_sql = f.read()
    operations.append(migrations.RunSQL(whdb_sql))
```

## Data

Using WebhookDB in the tests themselves is far more straightforward.

Let's say that in your application you want to look at a user's bank transactions
to see if they've been paying their rent. You are using our [Plaid integration]({% link _integrations/plaid.md %})
to connect to a user's bank account.

You would store the user's Plaid Account ID in your database.
Then we can look through their bank account transactions for a relevant row.

```ruby
DB = Sequel.connect(ENV['DATABASE_URL'])
WHDB_CONN = Sequel.connect(ENV['WHDB_DATABASE_URL'])
WHDB_PLAID_TRANSACTIONS_TABLE = ENV['WHDB_STRIPE_CHARGES_TABLE'].to_sym

def paid_rent?(plaid_account_id)
  !WHDB_CONN[WHDB_PLAID_TRANSACTIONS_TABLE].
    where(account_id: plaid_account_id).
    where { (amount > 1500) & (amount < 3000) & (date > 30.days.ago) }.
    empty?
end
```

We want to write a unit test to verify we only find the right transactions:

```ruby
it "considers rent paid if there is a recent payment of about $2000" do
  WHDB_CONN[WHDB_PLAID_TRANSACTIONS_TABLE].insert({account_id: 'diff_id', amount: 2000, date: Date.today})
  WHDB_CONN[WHDB_PLAID_TRANSACTIONS_TABLE].insert({account_id: 'my_id', amount: 1000, date: Date.today})
  WHDB_CONN[WHDB_PLAID_TRANSACTIONS_TABLE].insert({account_id: 'my_id', amount: 3001, date: Date.today})
  WHDB_CONN[WHDB_PLAID_TRANSACTIONS_TABLE].insert({account_id: 'my_id', amount: 2000, date: 35.days.ago})
  expect(paid_rent?('myid')).to be_falsey
  WHDB_CONN[WHDB_PLAID_TRANSACTIONS_TABLE].insert({account_id: 'my_id', amount: 2000, date: 20.days.ago})
  expect(paid_rent?('myid')).to be_truthy
end
```

This unit requires no HTTP mocking, no reference in the Plaid API, no unknowns.
It took a couple minutes to write. That's the power of working with WebhookDB when writing unit tests.

Needless to say, the application code is also many times faster than
having to check Stripe via its API.

You can see more examples in the [webhookdb-demos repo](https://github.com/webhookdb/webhookdb-demos) on GitHub.

#TODO

{% include prevnext.html prev="docs/getting-started/monitor.md" next="docs/integrating/index.md" nextLabel="Next (Integrating WebhookDB)" %}