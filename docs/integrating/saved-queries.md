---
title: Saved Queries
layout: home
parent: Integrating WebhookDB
nav_order: 50
---

# Saved queries

WebhookDB gives you the ability to save queries, which can be called over HTTP and securely run against your data.

The main benefit of this is to allow you to embed something like a dashboard on a public site.
For example, the [render a map from RSS tutorial]({% link _guides/render-map.md %})
uses a saved query so that a static web page can query dynamic web content from your database,
all without needing a server or complex client code munging.

You can think of saved queries as serverless endpoints.
Each saved query becomes an application endpoint, so to speak.

To get started, you'll first want to figure out your query.
You can run `webhookdb db connection` to get your connection info.
Figure out your SQL using your SQL editor of choice.

Once you have your SQL, create the query and follow the prompts:

    $ webhookdb saved-query create
    What is the query used for? testing things out
    Enter the SQL you would like to run: SELECT NOW()

You can now see your saved queries:

```
$ webhookdb saved-query list
               ID             DESCRIPTION         PUBLIC                                   RUN URL
svq_90qvnhfinkpikedgs8z42zhrr  testing things out  false   https://api.webhookdb.com/v1/saved_queries/svq_90qvnhfinkpikedgs8z42zhrr/run
```

If you want to make your query public, you can update it:

```
$ webhookdb saved-query update svq_90qvnhfinkpikedgs8z42zhrr
What field would you like to update (one of: description, sql, public): public
What is the new value? on
You have updated 'public' of saved query 'svq_90qvnhfinkpikedgs8z42zhrr'.
```

You can also modify the SQL (and use command line flags rather than prompts):

```
$ webhookdb saved-query update --field=sql --value="SELECT NOW() + '1 day'::interval as tomorrow" svq_90qvnhfinkpikedgs8z42zhrr
You have updated 'sql' of saved query 'svq_90qvnhfinkpikedgs8z42zhrr'.
```

Run the query using the URL output from `webhookdb saved-query list` that we saw above:

```
$ curl https://api.webhookdb.com/v1/saved_queries/svq_90qvnhfinkpikedgs8z42zhrr/run
{"rows":[["2024-02-05T22:25:14.356+00:00"]],"headers":["tomorrow"],"max_rows_reached":false}
```

You can also retrieve the "run url" (or the sql and other fields) using `webhookdb saved-query info`:

```
$ webhookdb saved-query info --field=run_url svq_90qvnhfinkpikedgs8z42zhrr
$ curl `webhookdb saved-query info --field=run_url svq_90qvnhfinkpikedgs8z42zhrr`
{"rows":[["2024-02-05T22:25:14.356+00:00"]],"headers":["tomorrow"],"max_rows_reached":false}
```

Finally, you can delete the saved query if you're not using it anymore:

```
$ webhookdb saved-query delete svq_90qvnhfinkpikedgs8z42zhrr
You have successfully deleted the saved query 'testing it out'.
```

## Advanced use cases

The [Render a map from RSS tutorial]({% link _guides/render-map.md %})
replicates the [pdxreporter.org](https://pdxreporter.org) RSS feed into WebhookDB
using the [atom_single_feed_v1 replicator]({% link _integrations/atom_single_feed_v1.md %}),
and then displays all issues on a map.

This can be done with minimal client-side code by doing some processing in the Postgres query.
The client-side is a single HTML file, with inline JavaScript that makes
an HTTP request to a public Saved Query, and renders markers on a map.
It requires no complex client-side logic and no server.

## Query troubleshooting

Your query is executed using your organization's read-only connection string.
It has access to all the tables in your organization's database.

Your SQL is validated when you create or update the saved query.
If the query stops working, the `/run` endpoint will error with an HTTP 400 error.

To see what went wrong, first grab the SQL:

```
$ webhookdb saved-query info --field=sql svq_m7c4zgy4sfza0eqwic7wqavc
SELECT one
```

Then get your organization's connection string:

```
$ webhookdb db connection
postgres://aro34ac386a3185e0e549b:a34aa0f77ec50047f58e@myorg.webhookdb.com/adb34a84355a72a38a1064
```

Then connect to your database, run your query, see what the error is, and fix your query.

Once your query is fixed, you can update your saved query with the new sql:

```
$ webhookdb saved-query update --field=sql svq_m7c4zgy4sfza0eqwic7wqavc
What is the new value? SELECT 1
You have updated 'sql' on saved query 'svq_m7c4zgy4sfza0eqwic7wqavc'.
```

{% include prevnext.html prev="docs/integrating/error-handlers.md" %}
