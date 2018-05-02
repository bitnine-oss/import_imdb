# import_imdb
This script will import IMDB data from the relational database created by IMDBpy into AgensGraph. [AgensGraph](http://bitnine.net/agensgraph/) is a graph database platform that runs off of PostgreSQL and is queryable with both SQL and the Cypher Query Language for graph databases. Representing IMDB data as graph data helps to provide an intuitive way to query and visualize connections between cast and crew and the productions that they work on.

## Getting Started

### Prerequisites

Download the [IMDb Dataset](http://www.imdb.com/interfaces)
You can download the following ftp command:
```
wget -r -l1 -np -nd -P data ftp://ftp.fu-berlin.de/pub/misc/movies/database/
```

Install [IMDbPy](http://imdbpy.sourceforge.net/). IMDbPy is a Python package that helps developers develop programs using the IMDb database. The script 'imdbpy2sql.py' will be used to import the IMDb database CSV files into a Agensgraph as a relational database.
[Documentation for imdbpy2sql.py](http://imdbpy.sourceforge.net/docs/README.sqldb.txt)

Install [AgensGraph](https://github.com/bitnine-oss/agensgraph). We need a running copy of AgensGraph to be able to import the data from IMDB. [AgensGraph Quick Start Guide](http://bitnine.net/support/documents_backup/quick-start-guide-html/)

Install [psycopg](http://initd.org/psycopg/). 

### Installation

After downloading and installing all the necessary components, it would be wise to set a few parameters to optimize AgensGraph.

Look in $AGDATA/postgresql.conf. Resizing 'shared_buffers' and 'work_mem' may reduce runtime.

To begin the import, first create a database called 'imdb':

```
>> createdb imdb
```

After the database is created, begin the import. Locate 'imdbpy2sql.py' (included in imdbpy2sql) on your system and run the following command:

```
>> python imdbpy2sql.py -d [/dir/with/plainTextDataFiles/] -u postgresql://[postgresUser]@localhost/[databasename] -c /directory/where/to/store/CSVfiles
```

With this, all of the IMDb data should be stored in the 'imdb' database in relational tables. Now, give permissions to execute to and run the script 'imdb_agens.sh'.

```
./imdb_agens.sh
```

With this, there should be a fully functional graph database of IMDb data in AgensGraph.

## Using the Graph Database
The Graph database stores four main entities as nodes with node labels: Person, Production, Company and Keyword.
They each have their own properties. Productions lie at the "center" of the graph database, with edge relationships leading in to Productions.

### Relationships between Entities
The possible relationships are stored in edges as follows:

Person to Production:

* ACTOR_IN
* ACTRESS_IN
* PRODUCER_OF
* WRITER_OF
* CINEMATOGRAPHER_OF
* COMPOSER_FOR
* COSTUME_DESIGNER_FOR
* DIRECTOR_OF
* EDITOR_OF
* MISC_CREW_OF
* PRODUCTION_DESIGNER_FOR
* GUEST_IN

These relationships describe what kind of role that a Person may have had in a Production.

 Production to Production:
 
* FOLLOWS
* FOLLOWED_BY
* REMAKE_OF
* REMADE_AS
* MAKES_REFERENCES_TO
* REFERENCED_IN
* SPOOFS
* SPOOFED_IN
* FEATURES
* FEATURED_IN
* SPIN_OFF_FROM
* SPIN_OFF
* VERSION_OF
* SIMILAR_TO
* EDITED_INTO
* EDITED_FROM
* ALTERNATE_LANGUAGE_VERSION_OF
* UNKNOWN_LINK

These relationships describe what kind of links that tie Productions with each other.

Keyword to Production:

* KEYWORD_OF

This relationship ties keywords to productions.

Company to Production:

* DISTRIBUTED
* PRODUCED
* DID_SPECIAL_EFFECTS_FOR
* MISC_WORK_ON

These relationships describe what kind of work a production company did for a production.

It is possible to query any of these relationships between entities that exist in the database.

### Information Storage in Entities

There are pieces of data about persons, productions, keywords and companies that are stored within the edges themselves. They are stored in the JSONB format. Since there is a lot of incomplete information fields for certain items in the database, some items in the database may be lacking 'info' fields that others may have. Rather than storing these fields as 'null', AgensGraph does not have these fields entirely if they are not present. JSONB is a binary format that stores all information as text. Some items in the database can be intrepreted as different data types, so to access them as such, sometimes a cast is necessary.

### Sample Queries
Here are some possible queries that can be used to explore the IMDb database using AgensGraph and Cypher.

Find the name of all actors that acted in a certain Production:
```
MATCH (a:Person)-[:ACTOR_IN]->(b:Production)
WHERE b.id::int = 'some_movie_id_number'
RETURN a.name,b.title;
```

Find all productions that a person has worked on in one form or another:
```
MATCH (a:Person)-[b]->(c:Production)
WHERE a.id::int = 'some_person_id_number'
RETURN a.name,b,c.title;
```

Find all other actresses that an actresses has worked with:
```
MATCH (a:Person)-[b:ACTRESS_IN]->(c:Production)<-[d:ACTRESS_IN]-(e:Person)
WHERE a.id::int = 'some_person_id_number'
RETURN a.name,e.name;
```

## Useful Links

[Cypher Query Language Reference](https://neo4j.com/docs/cypher-refcard/current/)
