Some experiments with [D3](http://d3js.org) in visualizing details of a Lucene index via the Solr APIs.  Primarily a learning exercise.

![Bubble Map](opensourceconnections_com_bearded-wookie_bubble_bubble2_html.png)
The bubble map shows you how many terms there are per field.

![](opensourceconnections_com_bearded-wookie_treemap_.png)
The treemap example was more ambitious and came out in response to someone asking me for a "schema" diagram like you would have for a traditional relational database.  Since we have just a single wide table, what could I show?   In the demo I show each field, with a color coding grouping of the hierarchy of field types, as Solr understands them.  For example, a `TrieLongField` is a subclass of a `TrieField`.   The size of the box shows you how big the field is in relationship to overall field size.

The Terms option shows you the term count per field in relationship to all the other fields.

The All Fields option shows you all the fields that you have defined in your `schema.xml`, and lets you see what fields you define but don't use.

The Memory option attempts to use the rules that are defined in this Memory calculator spreadsheet:
[https://svn.apache.org/repos/asf/lucene/dev/trunk/dev-tools/size-estimator-lucene-solr.xls](https://svn.apache.org/repos/asf/lucene/dev/trunk/dev-tools/size-estimator-lucene-solr.xls)   It's not perfect though!

A online demo is posted at [http://opensourceconnections.com/bearded-wookie/](http://opensourceconnections.com/bearded-wookie/)


## How to run locally

```bash
ruby -run -e httpd . -p 9090
```

And then browse to [http://localhost:9090/bubble/bubble2.html](http://localhost:9090/bubble/bubble2.html) and [http://localhost:9090/treemap/](http://localhost:9090/treemap/)
