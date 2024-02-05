---
title: Building a Map from an RSS Feed
layout: home
nav_order: 32
---

# Build a Map from an RSS Feed
{: .no_toc }

For this guide, we'll go through a real-world use case.
The non-profit [BikeLoud PDX](https://bikeloudpdx.org) wanted to build a way to display issues
from [PDX Reporter](https://pdxreporter.org/) on a map.
The City of Portland used to provide this, but stopped doing so.

This type of thing seems, and should be, simple, but can quickly get out of hand.

Using WebhookDB, BikeLoud was able to break down the work into three straightforward pieces:

- Use WebhookDB to replicate the PDX Reporter RSS feed into a database.
- Build a query against that database to get data to render markers.
- Serve a static webpage with the map.

1. TOC
{:toc}

## Replicate the RSS feed

PDX Reporter has an RSS feed at <https://www.portlandoregon.gov/shared/cfm/trackit_devicerss.cfm>.
It serves the last 100 reports.

We can replicate this feed into WebhookDB. This allows us to query the feed with SQL,
but it also stores reports in perpetuity, allowing us access to the full reporting history
rather than just the last 100.

1. Go to <https://api.webhookdb.com/terminal>.
2. Log in: `webhookdb auth login`
3. After you log in, replicate the RSS feed: `webhookdb integrations create atom_single_feed_v1`.
4. It will prompt you for the URL. Enter `https://www.portlandoregon.gov/shared/cfm/trackit_devicerss.cfm`.
5. The CLI will output your connection string. You can use this in your SQL editor.
6. If you have the `webhookdb` executable (see <{% link docs/getting-started/install-cli.md %}>),
   you can use ``psql `webhookdb db connection` `` to get the connection URL and connect to it using `psql`. 

## Build your query

Our query should select all the data we need, in the format we want to display it.
For example:

- Columns like `title`, `geo_lat`, and `geo_lng` can be used as-is.
- We can use the `timezone()` and `to_char()` functions to convert the `published` column
  to what we want to display (we do not need to use client-side time formatting since we are dealing with a single city).

However, the feed has some structured data stored in the `content` field, as HTML.
It has content like `<dl><dd>Address</dd><dt>123 MAIN ST</dt><dd>Comment</dd><dt>Gravel in bike lanes.</dt></dl>`.

We need to extract this from HTML, into cleaned fields in the `SELECT` query.

We *could* do this in JavaScript on the client. But in our opinion, it's a lot simpler to do it with the database query.
There's less code, iteration is faster, and let's face it, vanilla JavaScript can be really annoying to use.


but it will make the client code less portable; one of the nice aspects of doing this in the query is that, we can modify the SQL, which is like modifying the backend,
without requiring changes to the client.

This query looks worse than it is; it involves some string munging to turn HTML into XML,
and then some XPath, which would be the same in any language.
The code on the client would be similar, if more verbose.

Here is the final SQL we can use to get all our structured map marker data:

{: .notice }
Make sure you use the table name from your replicator, not the one hard-coded here!
It will have been output after you created your replicator,
or you can use `webhookdb integration info atom_single_feed_v1`.

```sql
WITH n AS (
    SELECT (
               '<root>' ||
                replace(
                        regexp_replace(
                                regexp_replace(
                                        replace(
                                                replace(data -> 'content' ->> 'value', '&lt;', '<'),
                        '&gt;', '>'),
                    E'^[\n\s\t]*', ''
                ),
                E'[\n\s\t]*$', ''
            ),
            'width=200&amp;height=200">', 'width=200&amp;height=200"></img>'
        ) ||
        '</root>')::xml AS contentxml,
        title,
        to_char(timezone('America/Los_Angeles', published), 'FMDy Mon FMDD, YYYY FMHH:MI am') as published,
        geo_lat,
        geo_lng,
        entry_id,
        data->>'status' AS status,
        data->'category'->>'term' as category
    FROM atom_single_feed_v1_4844
)
(
    SELECT
         title,
         published,
         geo_lat,
         geo_lng,
         status,
         category,
         entry_id,
         (xpath(E'/root/dl/dt[text()=\'Address\']/following-sibling::dd[1]/text()', contentxml)::text[])[1] as address,
         (xpath(E'/root/dl/dt[text()=\'Comments\']/following-sibling::dd[1]/text()', contentxml)::text[])[1] as comment
    FROM n
    ORDER BY published DESC
);
```

## Create the saved query

Now that we have our SQL, we can create the query. Copy the SQL you wrote, then create the saved query,
pasting your query when prompted for the SQL:

```
$ webhookdb saved-query create
What is the query used for? PDX Reporter Map
Enter the SQL you would like to run:
```

Make it public (make note of your saved query ID, starting with `cq_`):

```
$ webhookdb saved-query update --field=public --value=true cq_m7c4zgy4sfza0eqwic7wqavc
You have updated saved query cq_m7c4zgy4sfza0eqwic7wqavc with public set to true
```

If you need to modify the saved query, run:

    $ webhookdb saved-query update --field=sql cq_m7c4zgy4sfza0eqwic7wqavc

## Render your map

Let's see what our results look like:

    $ webhookdb saved-query list

Look at the `RUN URL` column, and copy the URL, and pass it to `curl`.
Or we can fetch it inline:

   $ curl `webhookdb saved-query info --field=run_url cq_m7c4zgy4sfza0eqwic7wqavc`

That should print out the response, with the shape `{"rows": []}`.

If that's all working, we can put our map together.