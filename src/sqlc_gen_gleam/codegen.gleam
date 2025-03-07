import gleam/dynamic/decode as d
import gleam/io
import gleam/json
import gleam/list
import gleam/string
import simplifile
import sqlc_gen_gleam/config.{
  type Config, Config, get_json_file, get_module_directory, get_module_path,
}
import sqlc_gen_gleam/internal/lib
import sqlc_gen_gleam/internal/project
import sqlc_gen_gleam/internal/sqlc.{type SQLC}
import sqlc_gen_gleam/internal/string_case

pub fn codegen_from_config(config: Config) {
  use json_string <- lib.try_nil(get_json_file(config))

  use dyn_json <- lib.try_nil(json.parse(from: json_string, using: d.dynamic))

  let assert Ok(parsed) = sqlc.decode_sqlc(dyn_json)

  let module_contents = gen_gleam_module(parsed)

  let _ =
    get_module_directory(config)
    |> simplifile.create_directory_all()
  let _ =
    simplifile.write(to: get_module_path(config), contents: module_contents)
    |> io.debug

  Ok(Nil)
}

fn gen_query(query: sqlc.Query) {
  let type_str = case list.length(query.columns) {
    0 -> ""
    _ -> gen_query_type(query) <> "\n\n"
  }

  type_str <> gen_query_function(query)
}

pub fn sqlc_type_to_gleam(sqltype: String) {
  case string.lowercase(sqltype) {
    "integer" -> "Int"
    "bigint" -> "Int"
    "text" -> "String"
    _ -> panic as { "unknown type mapping: " <> sqltype }
  }
}

pub fn gen_query_type(query: sqlc.Query) {
  let name = string_case.pascal_case(query.name)

  let args =
    query.columns
    |> list.map(fn(col) {
      let col_type = sqlc_type_to_gleam(col.type_ref.name)
      let col_type = case col.not_null {
        True -> col_type
        False -> "Option(" <> col_type <> ")"
      }
      col.name <> ": " <> col_type
    })
    |> list.map(fn(str) { "    " <> str })
    |> string.join(",\n")

  ["pub type " <> name <> " {", "  " <> name <> "(", args, "  )", "}"]
  |> string.join("\n")
}

pub fn gen_query_function(query: sqlc.Query) {
  let fn_name = string_case.snake_case(query.name)

  let def_fn_args =
    query.params
    |> list.map(fn(p) {
      p.column.name <> ": " <> sqlc_type_to_gleam(p.column.type_ref.name)
    })
    |> string.join(", ")

  let def_return_params = case query.params {
    [] -> "Nil"
    args ->
      args
      |> list.map(fn(arg) { arg.column.name })
      |> string.join(", ")
  }

  let def_fn = "pub fn " <> fn_name <> "(" <> def_fn_args <> ")"
  let def_sql = "let sql = \"" <> query.text <> "\""
  let def_return = "#(sql, " <> def_return_params <> ")"

  [def_fn <> "{", "  " <> def_sql, "  " <> def_return, "}"]
  |> string.join("\n")
}

pub fn gen_gleam_module(schema: SQLC) {
  let queries =
    schema.queries
    |> list.map(gen_query)
    |> string.join("\n\n")

  let imports = "import gleam/option.{type Option}"

  comment_dont_edit() <> "\n\n" <> imports <> "\n\n" <> queries
}

pub fn comment_dont_edit() {
  let assert Ok(version) = project.version()
  "
  //// Code generated by sqlc_gen_gleam. DO NOT EDIT.
  //// versions:
  ////   sqlc_gen_gleam v{version}
  ////
  "
  |> string.replace("{version}", version)
  |> lib.dedent
}
