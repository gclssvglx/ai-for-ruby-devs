# AI for Ruby Devs

## Getting started

```shell
bundle install
```

You'll need to run a Vector database. PostgreSQL will do just fine here as it supports vectors via the [PGVector extenstion](https://github.com/pgvector/pgvector).

There are 2 options to running PostgreSQL and PGVector - install the PGVector extension and enable it on an existing or new PostgreSQL installation, or by running a purpose built PostgreSQL Docker image with the PGVector extension already installed for us.

### Enable the PGVector extension in an existing PostgreSQL instance

```shell
psql postgres
postgres=# create extension vector;
postgres=# \q
```

### Running PGVector via a pre-built Docker image

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

Please note - if you are using a free OpenAI API account, requests are limited to 3 per minute. Because of this we are forced to add a `sleep 20.seconds` after each API call when building the Vector database. If you're using a paid-for account you can simply remove this line.

We are going to be loading the entire Markdown content of all pages from [The GDS Way](https://gds-way.cloudapps.digital), which at the time of creation had 56 files, so this process will take 18 minutes to load and 'vectorise' all of the data.

We've included all of the Markdown files from [The GDS Way pages](gds-way) for simplicity, but feel free to use your own version or your own content if you like.

```shell
ruby build_db.rb
```

### Run the web app

```shell
ruby app.rb
```
