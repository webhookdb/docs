---
title: MyAllocator
layout: home
nav_order: 2000
---

# MyAllocator
{: .no_toc }

1. TOC
{:toc}

{% include enterprise_integration.md %}

[MyAllocator](https://myallocator.github.io/build2us-apidocs/index.html) is a "build to us" API for the MyAllocator/CloudBeds
Channel Manager for OTAs.

WebhookDB helps you integrate their API so that you just need to set up
[HTTP Sync]({% link docs/integrating/httpsync.md %}) targets rather than
integrate the MyAllocator API directly, which can be quite difficult.

WebhookDB supports both 'shallow' and 'deep' (`CreateProperty`, `BookingCreate`) integrations with MyAllocator,
depending on the needs of your channel.

## Create Integrations

Creating the MyAllocator Partner Account integration with WebhookDB will create integrations
for all other resources, like properties, inventory, and bookings:

```
$ webhookdb integrations create myallocator_partner_account_v1
```

You'll be prompted for your Channel ID and Shared Secret.
These should have been provided to you by MyAllocator staff.

This command will give you a URL, like `https://api.webhookdb.com/v1/service_integrations/svi_abcd1234`,
which you should provide to MyAllocator staff as the URL for your integration.

{: .notice }
You can use your own domain by setting up a CNAME to point a subdomain of your choice,
like `channels.myawesomeota.com`, at `api.webhookdb.com`.

## Self-Certification

Follow MyAllocator staff instructions to begin the self-certification process.

Input your Channel ID and Shared Secret.

Continue through the Self-Certification screens.
No intervention should be needed for these:

- `HealthCheck`
- `CreateProperty`
- `SetupProperty`
- `GetRoomTypes`
- `GetRatePlans`
- `ARIUpdate`

### `UpdateResult`

At this point, the Self-Certification process will prompt you to confirm the inventory.
You can query it from your WebhookDB table:

```shell
$ webhookdb db tables
myallocator_partner_account_v1_c63e
myallocator_property_v1_b88e
myallocator_room_v1_4b13
myallocator_tax_v1_8403
myallocator_booking_v1_e42c
myallocator_inventory_v1_f733
myallocator_rate_plan_v1_be43
$ webhookdb db sql "SELECT data->>'date' as date, data->>'rate' as rate, data->>'rdef_single' as single_rate, data->>'units' as units, data->>'min_los' as min_los, data->>'max_los' as max_los FROM myallocator_inventory_v1_f733 WHERE date = (CURRENT_DATE + '1 day'::interval) OR date = (CURRENT_DATE + '2 days'::interval) ORDER BY row_updated_at DESC LIMIT 2"
+------------+--------+-------------+-------+---------+---------+
|    DATE    |  RATE  | SINGLE RATE | UNITS | MIN LOS | MAX LOS |
+------------+--------+-------------+-------+---------+---------+
| 2024-06-24 | 100.00 |       95.00 |     5 |       1 |       7 |
| 2024-06-23 | 120.00 |      115.00 |     5 |       1 |       0 |
+------------+--------+-------------+-------+---------+---------+
```

{: .notice }
You can also use `date = '2024-06-20'` or whatever date MyAllocator prompts you for,
it is usually 'tomorrow' and 'the day after tomorrow'.
You can also query the full `data` column if you need to see all available data.

Enter these results into the MyAllocator web UI, click 'Check', and continue.

### `BookingCreate`

Now we need to check the booking flow.
You can send the `BookingCreate` request to WebhookDB, and WebhookDB will update its database
and send the callback to MyAllocator.

The request to WebhookDB should follow the same instructions and format
as the [MyAllocator BookingCreate callback](https://myallocator.github.io/build2us-apidocs/index.html#tag/Callbacks/operation/booking_create).

```shell
$ export MYA_SHARED_SECRET=0b2cad74ae7bbec1c28d2a54762afc603c1d3179ab4c3917ae8ebaa60d1567ca
$ export MYA_URL=https://api.webhookdb.com/v1/service_integrations/svi_abcd1234
# Get the property information for this certification flow
$ webhookdb db sql "SELECT mya_property_id, ota_property_id FROM myallocator_property_v1_b88e ORDER BY row_updated_at DESC LIMIT 1"
+-----------------+--------------------------------------+
| MYA PROPERTY ID |           OTA PROPERTY ID            |
+-----------------+--------------------------------------+
|               1 | e1b58f99-9c77-4938-85e3-220e95cee346 |
+-----------------+--------------------------------------+
> webhookdb db sql "SELECT ota_room_id FROM myallocator_room_v1_4b13 ORDER BY row_updated_at DESC LIMIT 1"
+--------------------------------------+
|             OTA ROOM ID              |
+--------------------------------------+
| a8d3e591-4fc6-4a29-940d-3e8467608cb0 |
+--------------------------------------+
$ export MYA_PROP_ID=1
$ export MYA_OTA_PROP_ID=e1b58f99-9c77-4938-85e3-220e95cee346
$ export MYA_OTA_ROOM_ID=a8d3e591-4fc6-4a29-940d-3e8467608cb0
# We'll modify this in the next step
$ export MYA_IS_CANCELLATION=0
# Note the 'Mya-Self-Certification' header, so WebhookDB sends the BookingCreate request
# to the correct MyAllocator endpoint.
# The body here is the same body as in the BookingCreate example,
# with various pieces pulled out into environment variables.
$ curl -X POST -H "Mya-Self-Certification: 1" -d "mya_property_id=${MYA_PROP_ID}&shared_secret=${MYA_SHARED_SECRET}&ota_property_id=${MYA_OTA_PROP_ID}&booking_json=%7B%0A%20%20%22OrderId%22%3A%20%22123456789%22%2C%0A%20%20%22OrderDate%22%3A%20%222018-04-22%22%2C%0A%20%20%22OrderTime%22%3A%20%2218%3A02%3A58%22%2C%0A%20%20%22IsCancellation%22%3A%20${MYA_IS_CANCELLATION}%2C%0A%20%20%22TotalCurrency%22%3A%20%22USD%22%2C%0A%20%20%22TotalPrice%22%3A%20134%2C%0A%20%20%22Customers%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22CustomerCountry%22%3A%20%22US%22%2C%0A%20%20%20%20%20%20%22CustomerEmail%22%3A%20%22test%40test.com%22%2C%0A%20%20%20%20%20%20%22CustomerFName%22%3A%20%22Test%20Firstname%22%2C%0A%20%20%20%20%20%20%22CustomerLName%22%3A%20%22Test%20Lastname%22%0A%20%20%20%20%7D%0A%20%20%5D%2C%0A%20%20%22Rooms%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22ChannelRoomType%22%3A%20%22${MYA_OTA_ROOM_ID}%22%2C%0A%20%20%20%20%20%20%22Currency%22%3A%20%22USD%22%2C%0A%20%20%20%20%20%20%22DayRates%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22Date%22%3A%20%222017-11-08%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Description%22%3A%20%22Refundable%20Rate%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Rate%22%3A%2032.5%2C%0A%20%20%20%20%20%20%20%20%20%20%22Currency%22%3A%20%22USD%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22RateId%22%3A%20%2213649%22%0A%20%20%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22Date%22%3A%20%222017-11-09%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Description%22%3A%20%22Refundable%20Rate%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Rate%22%3A%2034.5%2C%0A%20%20%20%20%20%20%20%20%20%20%22Currency%22%3A%20%22USD%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22RateId%22%3A%20%2213649%22%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22StartDate%22%3A%20%222017-11-08%22%2C%0A%20%20%20%20%20%20%22EndDate%22%3A%20%222017-11-09%22%2C%0A%20%20%20%20%20%20%22Price%22%3A%20134%2C%0A%20%20%20%20%20%20%22Units%22%3A%202%0A%20%20%20%20%7D%0A%20%20%5D%0A%7D%0A" ${MYA_URL}/BookingCreate
```

### `NotifyBooking`

Since WebhookDB supports `CreateBooking`, check the 'Skip' checkbox and hit Check.

### `GetBookingList` and `GetBookingId`

These should 'just work', so go ahead and Check.

### `BookingCancellation`

This is the same as `BookingCreate`, but setting `IsCancellation=1`.
In the same shell as `BookingCreate` was run:

```shell
$ export MYA_IS_CANCELLATION=1
$ curl -X POST -H "Mya-Self-Certification: 1" -d "mya_property_id=${MYA_PROP_ID}&shared_secret=${MYA_SHARED_SECRET}&ota_property_id=${MYA_OTA_PROP_ID}&booking_json=%7B%0A%20%20%22OrderId%22%3A%20%22123456789%22%2C%0A%20%20%22OrderDate%22%3A%20%222018-04-22%22%2C%0A%20%20%22OrderTime%22%3A%20%2218%3A02%3A58%22%2C%0A%20%20%22IsCancellation%22%3A%20${MYA_IS_CANCELLATION}%2C%0A%20%20%22TotalCurrency%22%3A%20%22USD%22%2C%0A%20%20%22TotalPrice%22%3A%20134%2C%0A%20%20%22Customers%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22CustomerCountry%22%3A%20%22US%22%2C%0A%20%20%20%20%20%20%22CustomerEmail%22%3A%20%22test%40test.com%22%2C%0A%20%20%20%20%20%20%22CustomerFName%22%3A%20%22Test%20Firstname%22%2C%0A%20%20%20%20%20%20%22CustomerLName%22%3A%20%22Test%20Lastname%22%0A%20%20%20%20%7D%0A%20%20%5D%2C%0A%20%20%22Rooms%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22ChannelRoomType%22%3A%20%22${MYA_OTA_ROOM_ID}%22%2C%0A%20%20%20%20%20%20%22Currency%22%3A%20%22USD%22%2C%0A%20%20%20%20%20%20%22DayRates%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22Date%22%3A%20%222017-11-08%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Description%22%3A%20%22Refundable%20Rate%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Rate%22%3A%2032.5%2C%0A%20%20%20%20%20%20%20%20%20%20%22Currency%22%3A%20%22USD%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22RateId%22%3A%20%2213649%22%0A%20%20%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22Date%22%3A%20%222017-11-09%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Description%22%3A%20%22Refundable%20Rate%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22Rate%22%3A%2034.5%2C%0A%20%20%20%20%20%20%20%20%20%20%22Currency%22%3A%20%22USD%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22RateId%22%3A%20%2213649%22%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22StartDate%22%3A%20%222017-11-08%22%2C%0A%20%20%20%20%20%20%22EndDate%22%3A%20%222017-11-09%22%2C%0A%20%20%20%20%20%20%22Price%22%3A%20134%2C%0A%20%20%20%20%20%20%22Units%22%3A%202%0A%20%20%20%20%7D%0A%20%20%5D%0A%7D%0A" ${MYA_URL}/BookingCreate
```

Use a Booking ID of "123456789", hit Check, and see that the check succeeds.

## Connecting WebhookDB to your Backend

You should set up your backend with endpoints that WebhookDB will call whenever resources are modified.
See the [docs on HTTP Sync]({% link docs/integrating/httpsync.md %}) for more information.
You will need an HTTP Sync for each resource:

```shell
$ webhookdb httpsync create myallocator_property_v1
$ webhookdb httpsync create myallocator_room_v1
$ webhookdb httpsync create myallocator_tax_v1
$ webhookdb httpsync create myallocator_booking_v1
$ webhookdb httpsync create myallocator_inventory_v1
$ webhookdb httpsync create myallocator_rate_plan_v1
```

These endpoints should transform the MyAllocator resources into native types for your application
and upsert them into your database.

Finally, your backend should call `BookingCreate` in WebhookDB
whenever a booking is created or modified by your backend.
For example, your backend code will look something like:

```ruby
# my_booking is the application model for your booking type
my_booking = MyOTA::Booking.get(my_booking_id)
# This renders the MyAllocator-compatible JSON, as detailed in
# https://github.com/MyAllocator/build2us-apidocs/blob/gh-pages/booking_format_b2u.md
mya_booking = MyOTA::MyAllocator.booking_as_json(my_booking)
# Generate the request body as per
# https://github.com/MyAllocator/build2us-apidocs/blob/gh-pages/booking_format_b2u.md
mya_booking_body = {
        shared_secret: ENV['MYA_SHARED_SECRET'],
        mya_property_id: my_booking.property.myallocator_id,
        ota_property_id: my_booking.property.id,
        # Note that this is a JSON string, NOT an object!
        booking_json: JSON.generate(mya_booking),
}
# Send the actual request
HTTParty.post(
        ENV['WEBHOOKDB_MYALLOCATOR_URL'] + "/BookingCreate", 
        body: URI.encode_www_form(mya_booking_body),
        headers: {'Content-Type' => "application/x-www-form-urlencoded"},
)
```

## Next Steps

At this point, every time MyAllocator updates any data, your backend will be notified;
and whenever you create or cancel a booking, you should call the BookingCreate callback as above.

## Getting Help

Integrating MyAllocator into your OTA is made much simpler by using WebhookDB,
but it's still not a trivial process.
If you need any help, we're here to assist.
Just email [hello@webhookdb.com](mailto:hello@webhookdb.com)
and we'll get back to you right away.
