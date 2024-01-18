---
title: Build a Replicator
layout: home
nav_order: 35
---

# Build a Replicator
{: .no_toc }

Here's the process we normally go through for building a replicator.

{: .notice}
The "replicator" is the custom API logic,
and the "service integration" is the DB model storing the data for the replicator).

1. TOC
{:toc}

We'll be adding a replicator for **Increase Accounts.**
Increase is a 'banking as a service' platform;
we use it here because its API is extremely standard.
Most APIs you'll run into are not as well-designed,
and will need more wrestling than this at the edge cases.

## Create new files

Create the file `lib/webhookdb/replicator/increase_account_v1.rb`.

{: .notice}
In the [webhookdb repo](https://github.com/webhookdb/webhookdb), this code is split into `increase_account_v1.rb` and `increase_v1_mixin.rb`.
However the mixin is straightforward so it's treated in this document as if it
is a part of `increase_account_v1.rb`.

We'll also create the file `lib/webhookdb/increase.rb`.
It will be slim for now, and just define a timeout we'll use when making HTTP calls.

```rb
class Webhookdb::Increase
  include Appydays::Configurable

  configurable(:increase) do
    setting :http_timeout, 30
  end
end
```

## Create the descriptor

Stub out the class and its "descriptor".
This descriptor defines basic metadata about the integration/replicator,
and it used to auto-generated documentation and in feedback messages to users.
See the type description for more information and available fields
(such as declaring dependencies).

{: .notice}
This replicator uses both webhooks (realtime updates) and backfilling
(support fetching historical data). This is ideal,
but many replicators support only one or the other.

```rb
class Webhookdb::Replicator::IncreaseAccountV1 < Webhookdb::Replicator::Base
  # @return [Webhookdb::Replicator::Descriptor]
  return Webhookdb::Replicator::Descriptor.new(
    name: "increase_account_v1",
    ctor: ->(sint) { self.new(sint) },
    feature_roles: [],
    resource_name_singular: "Increase Account",
    supports_webhooks: true,
    supports_backfill: true,
    api_docs_url: "https://increase.com/documentation/api",
  )
end
```

## Define the schema

Next up is defining the schema.

```rb
  def _remote_key_column
    return Webhookdb::Replicator::Column.new(:increase_id, TEXT, data_key: "id")
  end

  def _denormalized_columns
    return [
      Webhookdb::Replicator::Column.new(:balance, INTEGER, index: true),
      Webhookdb::Replicator::Column.new(
        :created_at,
        TIMESTAMP,
        data_key: "created_at",
        defaulter: :now,
        index: true,
      ),
      Webhookdb::Replicator::Column.new(:entity_id, TEXT, index: true),
      Webhookdb::Replicator::Column.new(:interest_accrued, DECIMAL),
      Webhookdb::Replicator::Column.new(:name, TEXT),
      Webhookdb::Replicator::Column.new(:status, TEXT),
      Webhookdb::Replicator::Column.new(
        :updated_at,
        TIMESTAMP,
        data_key: "created_at",
        event_key: "created_at",
        defaulter: :now,
        index: true,
      ),
    ]
  end

    def _update_where_expr
      return self.qualified_table_sequel_identifier[:updated_at] < Sequel[:excluded][:updated_at]
    end

  def _timestamp_column_name = :updated_at
```

Things to note here are:
- The `Column` class defines the column name, its type (and other schema info like indexing),
  and how the data goes from a 'data hash' (like you get from the API or a webhook)
  into the column. In the simplest case, as here, this means the data hash has a `created_at`
  key and it's parsed as a timestamp.
  - The `data_key` can be a string or array of strings, for nested lookup. 
  - A `converter` can be used to take a value and convert it to what's inserted. This is how, for example, a Unix timestamp integer is converted into a `TIMESTAMPTZ`.
   Look at `Webhookdb::Replicator::Column` for `CONV_` constants to see what's available.
   You can also write your own.
  - There is also a `defaulter` argument that can be used to set a default.
  - Converters and defaulters are 'isomorphic' to Ruby and SQL.
    This ensures that when a new column is added, existing rows can be backfilled.
  - See the `Column` type definition docs for other fields, like `optional` and `index`.
- The `_remote_key_column` gets a unique constraint. It should uniquely identify the resource **in the 3rd party system/API**.
- The `_denormalized_columns` returns the set of columns to put into the schema. Note that the entire payload is stored in the `data` column automatically, so only denormalize what is useful to query on and/or needs type coercion (especially times).
- The `_timestamp_column_name` is used to track changes to the table. It should be updated every time the data in the row changes. Ideally this is some sort of `updated_at` field from the API, but that isn't available in most APIs.
  - Increase webhooks contain a `created_at` key we can use as an update timestamp.
  - If that key isn't present, we default to 'now'.
  - If you don't have an event timestamp or updated_at field, you may want to use something like:
```rb
Webhookdb::Replicator::Column.new(
    :row_updated_at,
    TIMESTAMP,
    defaulter: :now,
    index: true,
  optional: true,
)
```

## Other abstract methods

There are some other methods that `raise NotImplementedError` on the base class,
and have documentation explaining what they are.

Refer to the `Webhookdb::Replicator::Base` documentation,
and other replicators, to understand how to implement these methods.
But they are briefly described here.

`_resource_and_event` is used for APIs that use a different payload in their webhooks
vs API requests. For example, Increase's API returns a list of accounts from
its API request, but its webhooks send those objects nested under `{"data":<object>}`.

```rb
def _resource_and_event(request)
  # Increase's handling is more involved than this but this works for demonstration
  body = request.body
  is_event = body.key?("event") && body.key?("event_id")
  resource = is_event ? body.fetch("data") : body
  id = resource['id']
  # Don't process webhooks we do not expect.
  return nil, nil unless id.include?('account')
  return resource, body if is_event
  return body, nil
end
```

`_update_where_expr` is used for conditional updating.
This is usually "the existing row is older than the new (excluded) row",
or "the existing data column is different than the new data column."

```rb
  def _update_where_expr
    return self.qualified_table_sequel_identifier[:updated_at] <
      Sequel[:excluded][:updated_at]
  end
```

## Webhooks

When a webhook comes in, it is verified by the replicator.
Return a `Webhookdb::WebhookResponse` based on whether it is valid.

{: .notice}
This is normally one of the most annoying parts of a replicator to build,
because the docs on verification that APIs provide are usually unclear.
Keep trying, and look at other replicators for examples.

```rb
def _webhook_response(request)
  http_signature = request.env["HTTP_X_BANK_WEBHOOK_SIGNATURE"]

  return Webhookdb::WebhookResponse.error("missing hmac") if http_signature.nil?

  request.body.rewind
  request_data = request.body.read

  computed_signature = OpenSSL::HMAC.hexdigest(
    OpenSSL::Digest.new("sha256"),
    self.service_integration.webhook_secret,
    request_data
  )

  if http_signature != "sha256=" + computed_signature
    # Invalid signature
    self.logger.warn "increase signature verification error"
    return Webhookdb::WebhookResponse.error("invalid hmac")
  end
  
  return Webhookdb::WebhookResponse.ok
end
```

## Backfilling

The simplest way to backfill is by providing a `_fetch_backfill_page` method
which fetches a single page via the API.

{: .notice}
See any replicators that override `_backfillers` for more complex backfill examples.

```rb
def _fetch_backfill_page(pagination_token, **_kwargs)
    query = {}
    (query[:cursor] = pagination_token) if pagination_token.present?
    response = Webhookdb::Http.get(
      "#{self.service_integration.api_url}/accounts",
      query,
      headers: {"Authorization" => ("Bearer " + self.service_integration.backfill_key)},
      logger: self.logger,
      timeout: Webhookdb::Increase.http_timeout,
    )
    data = response.parsed_response
    next_page_param = data.dig("response_metadata", "next_cursor")
    return data["data"], next_page_param
end
```

Note that we're passing a `timeout` defined on `Webhookdb::Increase`.
It's important all timeouts are configurable.

## State machine calculation

WebhookDB uses a "state machine" for replicator setup.
Some replicators require no setup, some require multiple steps.

{: .notice}
State machines, as used here, take state from the database,
and figure out what action to prompt the user with,
usually POSTing some new data to the backend.
When the user takes that action, the new state is derived.
**This is all done for you.** The state machine code you write is to determine
what action to prompt for, given the state of a service integration.

Each replicator has available the following fields.
The use of these fields can vary depending on the replicator,
the names are just suggestions.

{: .notice}
Remember that the "replicator" is the custom API logic,
and the "service integration" is the DB model storing the data for the replicator).

- `service_integration.webhook_secret`: Usually used to verify webhooks.
- `service_integration.backfill_key`: API token or key.
- `service_integration.backfill_secret`: Another API token or key (some APIs require username and password).
- `service_integration.api_url`: Some APIs require a custom API or subdomain,
  such as a Shopify store name. That is stored in `api_url`.

There are separate state machines for handling webhooks and handling backfilling.

### Webhook state machine

The webhook state machine prompts for a webhook secret.
If it is present, setup is complete.

```rb
  def calculate_webhook_state_machine
    step = Webhookdb::Replicator::StateMachineStep.new
    # if the service integration doesn't exist, create it with some standard values
    unless self.service_integration.webhook_secret.present?
      step.output = %(You are about to start replicating #{self.resource_name_plural} info into WebhookDB.
We've made an endpoint available for #{self.resource_name_singular} webhooks:

#{self._webhook_endpoint}

From your Increase admin dashboard, go to Applications -> Create Webhook.
In the "Webhook endpoint URL" field you can enter the URL above.
For the shared secret, you'll have to generate a strong password
(you can use '#{Webhookdb::Id.rand_enc(16)}')
and then enter it into the textbox.

Copy that shared secret value.)
      return step.secret_prompt("secret").webhook_secret(self.service_integration)
    end

    step.output = %(Great! WebhookDB is now listening for #{self.resource_name_singular} webhooks.
#{self._query_help_output}
In order to backfill existing #{self.resource_name_plural}, run this from a shell:

  #{self._backfill_command})
    return step.completed
  end
```

### Backfill state machine

The backfill state machine prompts for an API key, and then the API URL,
so you can use the replicator against a sandbox.

Finally, it verifies the backfill credentials.
It does this by making an API request through the backfill system
(as we'll build in a moment).
If they aren't valid, backfill fields are cleared and the state machine starts over.

```rb
  def calculate_backfill_state_machine
    step = Webhookdb::Replicator::StateMachineStep.new
    unless self.service_integration.backfill_key.present?
      step.output = %(In order to backfill #{self.resource_name_plural}, we need an API key.
From your Increase admin dashboard, go to Settings -> Development -> API Keys.
We'll need the Production key--copy that value to your clipboard.)
      return step.secret_prompt("API Key").backfill_key(self.service_integration)
    end

    unless self.service_integration.api_url.present?
      step.output = %(Great. Now we want to make sure we're sending API requests to the right place.
For Increase, the API url is different when you are in Sandbox mode and when you are in Production mode.
For Sandbox mode, the API root url is:

https://sandbox.increase.com

For Production mode, which is our default, it is:

https://api.increase.com

Leave blank to use the default or paste the answer into this prompt.)
      return step.prompting("API url").api_url(self.service_integration)
    end

    unless (result = self.verify_backfill_credentials).verified
      self.service_integration.replicator.clear_backfill_information
      step.output = result.message
      return step.secret_prompt("API Key").backfill_key(self.service_integration)
    end

    step.needs_input = false
    step.output = %(Great! We are going to start backfilling your #{self.resource_name_plural}.
#{self._query_help_output})
    step.complete = true
    return step
  end
```

## Unit tests

Well, we left this until the end, but it's the most important,
and generally most time-consuming, step, because it requires you to enumerate
all the assumptions made earlier, and write tests that assert the code written
conforms to the full suite of replicator contracts.

### Why this approach?

This is because, while in this example it would be possible to write a much more
slim set of tests and still have full confidence in what we wrote,
most replicators (and in fact, the actual Increase replicators)
have much more subtle behaviors. These subtle behaviors are best tested
by making sure the replicator as a whole adheres to a set of contracts.

Or put differently- replicators are designed as a fat base class
because the breadth of customizations are vast.
Replicators are not designed as "fulfill this clearly-defined contract"
because, after several years of working with API integration,
we don't believe such a contract exists that can cover most APIs.

### Writing your tests

Anyway- to write unit tests:

Create the file like `spec/webhookdb/replicator/increase_account_spec.rb`:
```rb
require "support/shared_examples_for_replicators"

RSpec.describe Webhookdb::Replicator::IncreaseAccountV1, :db do
end
```

Look through `lib/webhookdb/spec_helpers/shared_examples_for_replicators.rb` for behaviors
that apply to your replicator.

Look at other unit tests that use the shared behavior.

Implement the behavior. Note that some of them are nontrivial, especially ones that include API mocking. Two relevant behaviors here are:

```rb
  it_behaves_like "a replicator", "increase_account_v1" do
    let(:body) do
      JSON.parse(<<~JSON)
        {
          "event_id": "transfer_event_123",
          "event": "created",
          "created_at": "2020-01-31T23:59:59Z",
          "data": {
            "id": "account_in71c4amph0vgo2qllky",
            "balance": 100,
            "created_at": "2020-01-31T23:59:59Z",
            "currency": "USD",
            "entity_id": "entity_n8y8tnk2p9339ti393yi",
            "interest_accrued": "0.01",
            "interest_accrued_at": "2020-01-31",
            "name": "My first account!",
            "status": "open",
            "type": "account"
          }
        }
      JSON
    end
    let(:expected_data) { body["data"] }
  end

  it_behaves_like "a replicator that verifies backfill secrets" do
    let(:correct_creds_sint) do
      Webhookdb::Fixtures.service_integration.create(
        service_name: "increase_account_v1",
        backfill_key: "bfkey",
        api_url: "https://api.increase.com",
      )
    end
    let(:incorrect_creds_sint) do
      Webhookdb::Fixtures.service_integration.create(
        service_name: "increase_account_v1",
        backfill_key: "bfkey_wrong",
        api_url: "https://api.increase.com",
      )
    end

    let(:success_body) do
      <<~JSON
        {"data": [],"response_metadata": {}}
      JSON
    end
    def stub_service_request
      return stub_request(:get, "https://api.increase.com/accounts").
          with(headers: {"Authorization" => "Bearer bfkey"}).
          to_return(status: 200, body: success_body, headers: {})
    end

    def stub_service_request_error
      return stub_request(:get, "https://api.increase.com/accounts").
          with(headers: {"Authorization" => "Bearer bfkey_wrong"}).
          to_return(status: 401, body: "", headers: {})
    end
  end
```

Finally, test the webhook validation and state machine code with your own unit tests.
Let other replicators guide you, but make sure all the code is covered.

## Distribution

See [Custom Integrations]({% link _guides/custom-integrations.md %}) to learn how to distribute your code, beyond getting it merged upstream.
