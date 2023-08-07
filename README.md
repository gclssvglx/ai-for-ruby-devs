# AI for Ruby Devs

A simple AI ChatGPT app written in Ruby to try and understand how this stuff hangs together and works.

## Getting started

You'll need to run a Vector DB (e.g. Qdrant etc). However, our needs are simple and for this purpose we can just use PostgreSQL - with the PGVector addon installed. If you don't want to create that yourself, here's one you can run from a docker image...

```shell
docker run -p 5432:5432 -e POSTGRES_PASSWORD=postgres ankane/pgvector
```

If you want to run in background, add the `-d` flag to the above command.

Next, you'll need to create the database.

```shell
psql postgres
postgres=# create database ai_ruby;
postgres=# \q
```

Bundle the dependencies.

```shell
bundle install
```

Then, we need to create the tables and populate the database.

```shell
ruby build_db.rb
```

Finally, we can run the chat bot cli.

```shell
ruby cli.rb
```
