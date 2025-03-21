//// This module decodes the JSON generated by sqlc
////

import decode
import gleam/dynamic
import gleam/option.{type Option}

pub type TypeRef {
  TypeRef(catalog: String, schema: String, name: String)
}

pub type TableColumn {
  TableColumn(
    name: String,
    not_null: Bool,
    is_array: Bool,
    comment: String,
    length: Int,
    is_named_param: Bool,
    is_func_call: Bool,
    scope: String,
    table_alias: String,
    is_sqlc_slice: Bool,
    original_name: String,
    unsigned: Bool,
    array_dims: Int,
    table: Option(TableRef),
    type_ref: TypeRef,
  )
}

pub type TableRef {
  TableRef(catalog: String, schema: String, name: String)
}

pub type Table {
  Table(rel: TableRef, comment: String, columns: List(TableColumn))
}

pub type Schema {
  Schema(comment: String, name: String, tables: List(Table))
}

pub type Catalog {
  Catalog(
    comment: String,
    default_schema: String,
    name: String,
    schemas: List(Schema),
  )
}

pub type QueryCmd {
  One
  Many
  Exec
  ExecResult
}

pub type QueryParam {
  QueryParam(number: Int, column: TableColumn)
}

pub type Query {
  Query(
    text: String,
    name: String,
    cmd: QueryCmd,
    filename: String,
    columns: List(TableColumn),
    insert_into_table: Option(TableRef),
    comments: List(String),
    params: List(QueryParam),
  )
}

pub type SQLC {
  SQLC(
    sqlc_version: String,
    plugin_options: String,
    global_options: String,
    catalog: Catalog,
    queries: List(Query),
  )
}

pub fn decode_sqlc(data: dynamic.Dynamic) {
  let table_ref_decoder =
    decode.into({
      use catalog <- decode.parameter
      use schema <- decode.parameter
      use name <- decode.parameter
      TableRef(catalog, schema, name)
    })
    |> decode.field("catalog", decode.string)
    |> decode.field("schema", decode.string)
    |> decode.field("name", decode.string)

  let type_ref_decoder =
    decode.into({
      use catalog <- decode.parameter
      use schema <- decode.parameter
      use name <- decode.parameter
      TypeRef(catalog, schema, name)
    })
    |> decode.field("catalog", decode.string)
    |> decode.field("schema", decode.string)
    |> decode.field("name", decode.string)

  let table_col_decoder =
    decode.into({
      use name <- decode.parameter
      use not_null <- decode.parameter
      use is_array <- decode.parameter
      use comment <- decode.parameter
      use length <- decode.parameter
      use is_named_param <- decode.parameter
      use is_func_call <- decode.parameter
      use scope <- decode.parameter
      use table_alias <- decode.parameter
      use is_sqlc_slice <- decode.parameter
      use original_name <- decode.parameter
      use unsigned <- decode.parameter
      use array_dims <- decode.parameter
      use table <- decode.parameter
      use type_ref <- decode.parameter

      TableColumn(
        name,
        not_null,
        is_array,
        comment,
        length,
        is_named_param,
        is_func_call,
        scope,
        table_alias,
        is_sqlc_slice,
        original_name,
        unsigned,
        array_dims,
        table,
        type_ref,
      )
    })
    |> decode.field("name", decode.string)
    |> decode.field("not_null", decode.bool)
    |> decode.field("is_array", decode.bool)
    |> decode.field("comment", decode.string)
    |> decode.field("length", decode.int)
    |> decode.field("is_named_param", decode.bool)
    |> decode.field("is_func_call", decode.bool)
    |> decode.field("scope", decode.string)
    |> decode.field("table_alias", decode.string)
    |> decode.field("is_sqlc_slice", decode.bool)
    |> decode.field("original_name", decode.string)
    |> decode.field("unsigned", decode.bool)
    |> decode.field("array_dims", decode.int)
    |> decode.field("table", decode.optional(table_ref_decoder))
    |> decode.field("type", type_ref_decoder)

  let table_decoder =
    decode.into({
      use rel <- decode.parameter
      use comment <- decode.parameter
      use columns <- decode.parameter
      Table(rel, comment, columns)
    })
    |> decode.field("rel", table_ref_decoder)
    |> decode.field("comment", decode.string)
    |> decode.field("columns", decode.list(table_col_decoder))

  let schema_decoder =
    decode.into({
      use comment <- decode.parameter
      use name <- decode.parameter
      use tables <- decode.parameter
      Schema(comment, name, tables)
    })
    |> decode.field("comment", decode.string)
    |> decode.field("name", decode.string)
    |> decode.field("tables", decode.list(table_decoder))

  let catalog_decoder =
    decode.into({
      use comment <- decode.parameter
      use default_schema <- decode.parameter
      use name <- decode.parameter
      use schemas <- decode.parameter

      Catalog(comment, default_schema, name, schemas)
    })
    |> decode.field("comment", decode.string)
    |> decode.field("default_schema", decode.string)
    |> decode.field("name", decode.string)
    |> decode.field("schemas", decode.list(schema_decoder))

  let params_decoder =
    decode.into({
      use number <- decode.parameter
      use column <- decode.parameter
      QueryParam(number, column)
    })
    |> decode.field("number", decode.int)
    |> decode.field("column", table_col_decoder)

  let cmd_decoder =
    decode.string
    |> decode.then(fn(cmd) {
      case cmd {
        ":one" -> decode.into(One)
        ":many" -> decode.into(Many)
        ":exec" -> decode.into(ExecResult)
        ":execresult" -> decode.into(ExecResult)
        _ -> decode.fail("QueryCmd")
      }
    })

  let query_decoder =
    decode.into({
      use text <- decode.parameter
      use name <- decode.parameter
      use cmd <- decode.parameter
      use filename <- decode.parameter
      use columns <- decode.parameter
      use insert_into_table <- decode.parameter
      use comments <- decode.parameter
      use params <- decode.parameter
      Query(
        text,
        name,
        cmd,
        filename,
        columns,
        insert_into_table,
        comments,
        params,
      )
    })
    |> decode.field("text", decode.string)
    |> decode.field("name", decode.string)
    |> decode.field("cmd", cmd_decoder)
    |> decode.field("filename", decode.string)
    |> decode.field("columns", decode.list(table_col_decoder))
    |> decode.field("insert_into_table", decode.optional(table_ref_decoder))
    |> decode.field("comments", decode.list(decode.string))
    |> decode.field("params", decode.list(params_decoder))

  let decoder =
    decode.into({
      use sqlc_version <- decode.parameter
      use plugin_options <- decode.parameter
      use global_options <- decode.parameter
      use catalog <- decode.parameter
      use queries <- decode.parameter
      SQLC(sqlc_version, plugin_options, global_options, catalog, queries)
    })
    |> decode.field("sqlc_version", decode.string)
    |> decode.field("plugin_options", decode.string)
    |> decode.field("global_options", decode.string)
    |> decode.field("catalog", catalog_decoder)
    |> decode.field("queries", decode.list(query_decoder))

  decode.from(decoder, data)
}
