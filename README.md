# sqlc_gen_gleam

[![Package Version](https://img.shields.io/hexpm/v/sqlc_gen_gleam)](https://hex.pm/packages/sqlc_gen_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/sqlc_gen_gleam/)

# Project Status

**this library project is currently pre-alpha. it will be released under v1.0.0 once ready for usage.**

# Installation

```sh
gleam add sqlc_gen_gleam@1
```
```sh
$ gleam run -m sqlc_gen_gleam
```

Further documentation can be found at <https://hexdocs.pm/sqlc_gen_gleam>.

# Development

## Database

There are scripts to spawn MySQL or PostgreSQL docker container:
-  [MySQL Script](./scripts/mysql/docker.sh)
-  [PostgreSQL Script](./scripts/psql/docker.sh)

For example:
```sh
$ ./scripts/mysql/docker.sh
# or
$ ./scripts/psql/docker.sh
```

## Running the project and tests
```sh
$ gleam run   # Run the project
$ gleam test  # Run the tests
```

# Acknowledgements
- Thank you to `squirrel` ([Hex](https://hex.pm/packages/squirrel), [GitHub](https://github.com/giacomocavalieri/squirrel)) for a lot of the code and repository structure inspiration (https://github.com/giacomocavalieri)
- Thank you to `sqlc`([GitHub](https://github.com/sqlc-dev/sqlc), [Website](https://sqlc.dev/))

# License
[Apache License, Version 2.0](./LICENSE)
