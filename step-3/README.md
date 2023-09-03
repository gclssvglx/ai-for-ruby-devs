# Step 3 - Web UI with custom content

## Getting started

You'll need to run a Vector database. PostgreSQL will do just fine here as it supports vectors via the [PGVector extenstion](https://github.com/pgvector/pgvector).

There are 2 options to running PostgreSQL and PGVector - install the PGVector extension and enable it on an existing or new PostgreSQL installation, or running a purpose built PostgreSQL Docker image with the PGVector extension already installed for us.

### Enable the PGVector extension

```shell
psql postgres
postgres=# create extension vector;
postgres=# \q
```

### Running PGVector in a pre-built Docker image

```shell
docker run -p 5432:5432 -e POSTGRES_PASSWORD=postgres ankane/pgvector
```

If you want to run in background, add the `-d` flag to the above command.

### Create and database and configure access (if require)

```shell
psql postgres
postgres=# create database ai_ruby;
postgres=# grant all privileges on database ai_ruby to your-username;
postgres=# \q
```

### Populate the database 

```shell
ruby build_db.rb
```

### Run the web app

```shell
ruby app.rb
```
