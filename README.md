# sqlc_gen_gleam

[![Package Version](https://img.shields.io/hexpm/v/sqlc_gen_gleam)](https://hex.pm/packages/sqlc_gen_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/sqlc_gen_gleam/)

# Project Status

**this library project is currently pre-alpha. it will be released under v1.0.0 once ready for usage.**

# How it works

This library makes use of a [sqlc-gen-json plugin](https://github.com/daniellionel01/sqlc-gen-json),
which it then converts into gleam code.

So in a simplified manner, the pipeline looks like this:
```mermaid
graph LR
    SQL[SQL Queries] -- sqlc-gen-json --> JSON[JSON Schema]
    JSON -- sql-gen-gleam --> Gleam[Gleam Code]
```

# Installation

```sh
gleam add sqlc_gen_gleam@1
```
```sh
$ gleam run -m sqlc_gen_gleam
```

Further documentation can be found at <https://hexdocs.pm/sqlc_gen_gleam>.

# Currently unsupported sqlc functionality

- embeddeding structs (https://docs.sqlc.dev/en/stable/howto/embedding.html)

# Development

## 1. Database

There are scripts to spawn MySQL or PostgreSQL docker container:
-  [MySQL Script](./scripts/mysql/docker.sh)
-  [PostgreSQL Script](./scripts/psql/docker.sh)

For example:
```sh
$ ./scripts/mysql/docker.sh
# or
$ ./scripts/psql/docker.sh
```

## 2. Generating the JSON schema
This library uses the JSON schema, generated by [sqlc](https://sqlc.dev/), to generate gleam code.
To generate the JSON with the example schema & queries:
```sh
$ ./scripts/sqlc.sh # wrapper for "sqlc generate" with additional parameters
```

## 3. Running the project and tests
```sh
$ gleam run   # Run the project
$ gleam test  # Run the tests
```

# Acknowledgements
- This project was heavily inspired by `squirrel` ([Hex](https://hex.pm/packages/squirrel), [GitHub](https://github.com/giacomocavalieri/squirrel)). Thank you [@giacomocavalieri](https://github.com/giacomocavalieri)!
- Thank you to `sqlc`([GitHub](https://github.com/sqlc-dev/sqlc), [Website](https://sqlc.dev/))

# License
[Apache License, Version 2.0](./LICENSE)
