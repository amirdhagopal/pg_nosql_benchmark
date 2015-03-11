pg_nosql_benchmark
==================

This is tool for benchmarking Postgres and MongoDB insertion and retrieval performance for a simple query.

Introduction
-------------

This is a benchmarking tool, adapted from EnterpriseDB benchmark, to benchmark MongoDB 3.0.0 and Postgres 9.4.1 database.

The current version focuses on data ingestion and simple selection in single-instance environment.

This tool performs the following tasks to compare between MongoDB and PostgreSQL:
* The tool generates a large set of JSON and CSV documents (the number of documents is defined by the value of the variable json_rows in pg_nosql_benchmark)
* The data set is loaded into MongoDB and PostgreSQL using mongoimport and PostgreSQL's COPY command.
* The same data is loaded into MongoDB and PostgreSQL using the INSERT command.
* The tool executes 3 SELECT Queries in MongoDB & Post 

Data Format
------------

PostgreSQL

Table Creation

CREATE TABLE ${TABLE_NAME} (id bigint primary key,parent_id bigint, name varchar(100), application varchar(100), thumbnail bytea, notes text, is_deleted boolean)

Index Creation
CREATE INDEX ${TABLE_NAME}_app_idx ON ${TABLE_NAME}(application, parent_id, is_deleted)

Sample Insert:
INSERT INTO json_tables VALUES(1,8,'Name8','App8','thumbnail','notes',false);

Select Queries:
Query1: SELECT name FROM ${TABLE_NAME} WHERE  not is_deleted;
Query2: SELECT name, thumbnail, notes FROM ${TABLE_NAME} WHERE  application = 'APP1' and parent_id = 1 and not is_deleted;
Query3: SELECT name FROM ${TABLE_NAME} WHERE  is_deleted;

MongoDB

Index Creation
db.${COLLECTION_NAME}.ensureIndex( { application: 1, parent_id: 1, is_deleted: 1 });

Sample Insert
db.json_tables.insert({"id":1,"parent_id":8,"name": "Name8","application": "App8","thumbnail":"thumbnail","notes":"notes","is_deleted":false})

Select Operations:
Operation1: db.${COLLECTION_NAME}.find({ is_deleted: 'false'}, {name: 1})
Operation2: db.${COLLECTION_NAME}.find({ application: 'APP1', parent_id: 1, is_deleted: 'false'}, {name: 1, thumbnail: 1, notes: 1})
Operation3: db.${COLLECTION_NAME}.find({ is_deleted: 'true'}, {name: 1})


Requirements
------------

* pg_nosql_benchmark uses CentOS 6.4 or later, and is designed for PostgreSQL 9.4.1 and MongoDB 3.0.0. (For windows, the script could be run with GNU Core Utils)
* The configuration requires three servers
	* Load generating server
	* MongoDB server
	* PostgreSQL server
* The MongoDB server and the PostgreSQL server should be configured identically
* The script is designed to run from the central load-generating server, which must have access to the MongoDB and PostgreSQL servers.
* The following environment variables in pg_nosql_benchmark control the execution:

  PostgreSQL Variables:
```
For Windows
  PGHOME="/d/Program Files/PostgreSQL/9.4" # Installation location of PostgreSQL binaries.
  PGHOST="localhost"                       # Hostname/IP address of PostgreSQL
  PGPORT="5432"                            # Port number on which PostgreSQL is running.
  PGUSER="postgres"                        # PostgreSQL database username.
  PGPASSWORD="password"                    # PostgreSQL database users password.
  PGBIN="/d/Program Files/PostgreSQL/9.4/bin" # PostgreSQL binary location.

For Linux
   PGHOME=/usr/pgsql-9.4    # Installation location of PostgreSQL binaries.
   PGHOST="172.17.0.2"      # Hostname/IP address of PostgreSQL
   PGPORT="5432"            # Port number on which PostgreSQL is running.
   PGUSER="postgres"        # PostgreSQL database username.
   PGPASSWORD="postgres"    # PostgreSQL database users password.
   PGBIN=/usr/pgsql-9.4/bin # PostgreSQL binary location.
```

  MongoDB Variables:

```
For Windows
    MONGO="/c/Progra~1/MongoDB/Server/3.0/bin/mongo"              # Complete path of mongo Command binary
    MONGOIMPORT="/c/Progra~1/MongoDB/Server/3.0/bin/mongoimport"  # complete path of mongoimport binary
    MONGOHOST="localhost"                                         # Hostname/IP address of MongoDB
    MONGOPORT="27017"                                             # Port number on which MongoDB is running.
    MONGOUSER="mongo"                                             # Mongo database username
    MONGOPASSWORD="password"                                      # MongoDB database username's password
    MONGODBNAME="benchmark"                                       # mongoDB database name.

For Linux
   MONGO="/usr/bin/mongo"             # Complete path of mongo Command binary
   MONGOIMPORT="/usr/bin/mongoimport" # complete path of mongoimport binary
   MONGOHOST="172.17.0.3"             # Hostname/IP address of MongoDB
   MONGOPORT="27017"                  # Port number on which MongoDB is running.
   MONGOUSER="mongo"                  # Mongo database username
   MONGOPASSWORD="mongo"              # MongoDB database username's password
   MONGODBNAME="benchmark"            # mongoDB database name.
```

* To create the admin user in MongoDB use the following command on the MongoDB server:
```
   > db.createUser({ user: "mongo",
                     pwd: "mongo",
                     roles:[{ role: "userAdmin",
                              db: "benchmark"
                            }]
                    })
```

* To create the super user in PostgreSQL use the following command:
```
CREATE USER postgres PASSWORD '<password>' WITH SUPERUSER;
```

For more information on CREATE USER command in PostgreSQL, please check:
   http://www.postgresql.org/docs/9.4/static/sql-createuser.html

Recommended modules
--------------------
  The following packages are needed to run the benchmark tool:
  1. mongodb-win32-x86_64-2008plus-ssl-3.0.0-signed (MongoDB 3.0.0)
  2. postgresql-9.4.1-1-windows-x64.exe (PostgreSQL 9.4.1)
  3. bc-1.06.95-1.el6.x86_64
  4. git-1.7.1-3.el6_4.1.x86_64

Installation
------------

To install this tool on the load generating server, use the following command:

1. git clone git@github.com:amirdhagopal/pg_nosql_benchmark.git
2. git checkout query_branch
2. cd pg_mongo_benchmark
3. chmod +x pg_nosql_benchmark
