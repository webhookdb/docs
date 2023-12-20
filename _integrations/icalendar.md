---
title: iCalendar
layout: home
---

**NOTICE: Our iCalendar integration is still in beta.
We'd love for you to try it out!
Please email <a href="mailto:hello@webhookdb.com">hello@webhookdb.com</a>
to be added to our iCalendar beta.**

The [iCalendar](https://en.wikipedia.org/wiki/ICalendar) format is used to describe
calendars (and more) in a portable format.

While iCalendar seems simple at first glance, there is quite a lot of nuance to it,
especially around things like timezones, recurrence, and event cancellation/deletion.
And like all calendar data, it's really nice to be able to work with it as SQL.

WebhookDB makes it extremely easy to ingest iCalendar feeds into your database.
There are just a couple things to do on your side:

- Create the integrations via the WebhookDB CLI.
- POST to WebhookDB when a user links an iCalendar URL, which starts a periodic sync.
- POST to WebhookDB when a user unlinks their calendar, which deletes all rows for the user.

<a id="create-integrations"></a>

## [Create Integrations](#create-integrations)

There are two integrations involved: one for calendars, and one for the events on those calendars.

First we need to create the calendar integration:

    webhookdb integrations create icalendar_calendar_v1

You'll be prompted for the the "webhook secret" (like `zd3zate6c5zfs40zyn44gqwm`),
which will sign requests from your backend.
You'll then be given the "webhook endpoint" (like `https://api.webhookdb.com/v1/service_integrations/svi_abc123`)
which is where you will POST.

Then add the events integration:

    webhookdb integrations create icalendar_event_v1

Accept the prompt defaults to link them together.

## [Testing your Integration](#testing)

Before we start writing user data, let's use cURL and a public calendar URL
to make sure syncing is working.

We'll use the public Google Holiday Calendar for testing.

You'll need your endpoint and webhook secret as well (see 'Create Integrations' above).

```bash
# These values are from when you created the icalendar_calendar_v1 integration, as above
export WEBHOOKDB_ICALENDAR_ENDPOINT=https://api.webhookdb.com/v1/service_integrations/svi_alaxblg5llvxb2morb9hw4xs2
export WEBHOOKDB_ICALENDAR_SECRET=a3vgdtr0wje0ywjb73ic0ch3n

curl -X POST -d '{"type":"SYNC","external_id":"google-holiday","ics_url":"https://calendar.google.com/calendar/ical/en.usa%23holiday%40group.v.calendar.google.com/public/basic.ics"}' -H "Whdb-Webhook-Secret: ${WEBHOOKDB_ICALENDAR_SECRET}" -H "Content-Type: application/json" "${WEBHOOKDB_ICALENDAR_ENDPOINT}"
```

That's it- you will see data flowing into your database almost immediately.
You can connect to your database and query it (connection parameters are printed out
when you set up the integration, or you can use `webhookdb db connection`).

If for some reason you get a new refresh token, you can tell WebhookDB about it
(set the new one to `REFRESH_TOKEN`):

```bash
curl -X POST -d '{"type":"REFRESHED","external_owner_id":"test-user","refresh_token":"'"${REFRESH_TOKEN}"'"}' -H "Whdb-Webhook-Secret: ${WEBHOOKDB_ICALENDAR_SECRET}" -H "Content-Type: application/json" "${WEBHOOKDB_ICALENDAR_ENDPOINT}"
```

After you've checked out your data, you can delete all the data out of WebhookDB
if you want (or you can leave it- it'll keep syncing, and stop syncing once the token expires;
we show how to send new access tokens below).

```bash
curl -X POST -d '{"type":"UNLINK","external_owner_id":"test-user"}' -H "Whdb-Webhook-Secret: ${WEBHOOKDB_ICALENDAR_SECRET}" -H "Content-Type: application/json" "${WEBHOOKDB_ICALENDAR_ENDPOINT}"
```

<a id="sync"></a>

### [Sync](#sync)

When a user gives you their URL to sync, you send it to WebhookDB
along with the webhook secret:

```python
calendar_url = request.json['ics_url']
# You probably want to store the URL in your database, associated with the user
calendar_id = str(insert_calendar_row_for_user(current_user, calendar_url).id)
# Or we can just make some other unique external id:
# calendar_id = f'{current_user.id}-#{calendar_url}'

# Now update WebhookDB. Can also be done asynchronously/in a job system.
requests.post(
  os.getenv("WEBHOOKDB_ICALENDAR_ENDPOINT"),
  headers={"Whdb-Webhook-Secret": os.getenv("WEBHOOKDB_ICALENDAR_SECRET")},
  json={
    "type": "SYNC", 
    "external_id": calendar_id,
    "ics_url": calendar_url
  }
)
```

```bash
$ 
```

That's it! Your events will start syncing immediately.
WebhookDB will poll the URL for changes every few hours,
based on how often the service updates their iCalendar feeds.
Google Calendar, for example, only updates ICS feeds every 8 hours
(don't worry, we update more often than that, to make sure we don't miss an upstream refresh).

If you ever need to force a sync, you can make the same 'SYNC' request.

<a id="delete"></a>

### [Delete](#delete)

If your user unlinks their calendar, you should tell WebhookDB so it can delete all the data for that user.

```python
requests.post(
  os.getenv("WEBHOOKDB_ICALENDAR_ENDPOINT"),
  headers={"Whdb-Webhook-Secret": os.getenv("WEBHOOKDB_ICALENDAR_SECRET")},
  json={
    "type": "DELETE",
    "external_id": calendar_id
  }
)
```

<a id="event-data"></a>

## [Event Data](#event-data)

iCalendar is a text format that can be difficult to work with.
Most iCalendar client libraries, for example, are incomplete or incorrect in various ways
(this isn't their fault; portable calendars are just really difficult).

[This page](https://www.kanzaki.com/docs/ical/) is a great resource to understand iCalendar fields.

To make the data easier to use, the `icalendar_event_v1` parses the iCalendar text.

First, it extracts and schematizes the data into normal columns, like a text array
for `CATEGORIES`, an integer for `PRIORITY`, and date and timestamp (with timezone) columns
for all dates.

Second, the `data` column gives you access to the parsed-but-unprocessed iCalendar data;
you can even use this to reconstruct the original iCalendar text if needed, too,
but that should be rare. For example, this `VEVENT`:

```
BEGIN:VEVENT
DTSTART;TZID=America/Los_Angeles:20200220T170000
DTEND:20190820T190000Z
DTSTAMP:20230426T152258Z
ORGANIZER;CN=hello@webhookdb.com:mailto:hello@webhookdb.com
UID:79396C44-9EA7-4EF0-A99F-5EFCE7764CFE
ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;CN=hello@
webhookdb.com;X-NUM-GUESTS=0:mailto:hello@webhookdb.com
CREATED:20190813T175204Z
LAST-MODIFIED:20230218T223450Z
LOCATION:Headquarters\\n1 API Way\\nPortland OR 97214
STATUS:CONFIRMED
SUMMARY:Do Good
END:VEVENT
```

would be parsed into this `data` column:

```json
{
   "DTSTART": {
      "TZID": "America/Los_Angeles",
      "v": "20200220T170000"
   },
   "DTEND": {"v": "20190820T190000Z"},
   "DTSTAMP": {"v": "20230426T152258Z"},
   "ORGANIZER": {
      "CN": "hello@webhookdb.com",
      "v": "mailto:hello@webhookdb.com"
   },
   "UID": {"v": "79396C44-9EA7-4EF0-A99F-5EFCE7764CFE"},
   "ATTENDEE": [
      {
         "CUTYPE": "INDIVIDUAL",
         "ROLE": "REQ-PARTICIPANT",
         "PARTSTAT": "ACCEPTED",
         "CN": "hello@webhookdb.com",
         "X-NUM-GUESTS": "0",
         "v": "mailto:hello@webhookdb.com"
      }
   ],
   "CREATED": {"v": "20190813T175204Z"},
   "LAST-MODIFIED": {"v": "20230218T223450Z"},
   "LOCATION": {"v": "Headquarters\n1 API Way\nPortland OR 97214"},
   "STATUS": {"v": "CONFIRMED"},
   "SUMMARY": {"v": "Do Good"}
}
```

That is, the data parsing will:

- Provide each property's value in a `"v"` field,
- Parse all property _parameters_ into fields,
- Normalize the escaped `\\r`, `\\n`, and `\\t` into `\r`, `\n`, and `\t`,
- Use arrays for array properties like `ATTENDEE`.

Working with this structured data, rather than parsing raw iCalendar text,
means you don't need to worry about things
like parsing parameters with special characters,
iCalendar line continuations, and more.
If you do need access to the iCalendar text for an event,
please email <a href="mailto:hello@webhookdb.com">hello@webhookdb.com</a>
and ask us to turn it on for you.

<a id="next-steps"></a>

## [Next Steps](#next-steps)

Once WebhookDB is syncing, you have two options for getting the data back out:

1. Use SQL to query the database. Run `webhookdb db connection` to get your SQL connection string
   and query your iCalendar tables in your attached WebhookDB database.
2. Use HTTP Sync to get notified about updates.
   This is a powerful-but-simple way to update your own database objects
   whenever changes happen in your attached calendars.
   Check out the [docs on HTTP Sync](/docs/httpsync/).


<a id="getting-help"></a>

## [Getting Help](#getting-help)

We know from experience that using WebhookDB to sync iCalendar URLs
is a lot simpler than doing it yourself- minutes instead of hours or days.
But if you need any help, we're here to assist. Just email <a href="mailto:hello@webhookdb.com">hello@webhookdb.com</a>
and we'll get back to you right away.
