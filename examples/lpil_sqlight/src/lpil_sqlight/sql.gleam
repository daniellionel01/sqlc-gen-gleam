//// Code generated by parrot. DO NOT EDIT.
//// versions:
////   parrot v1.0.0
////

import gleam/option.{type Option}
import gleam/dynamic/decode
import gleam/time/timestamp.{type Timestamp}
import parrot/sql

pub type GetCatsByAge {
  GetCatsByAge(
    created_at: Option(String),
    name: Option(String),
    age: Option(Int)
  )
}

pub fn get_cats_by_age(age: Int){
  let sql = "select
  created_at,
  name,
  age
from
  cats
where
  age < ?"
  #(sql, [sql.ParamInt(age)])
}

pub fn get_cats_by_age_decoder() -> decode.Decoder(GetCatsByAge) {
  use created_at <- decode.field(0, decode.optional(decode.string))
  use name <- decode.field(1, decode.optional(decode.string))
  use age <- decode.field(2, decode.optional(decode.int))
  decode.success(GetCatsByAge(created_at: , name: , age: ))
}

pub type CountCats {
  CountCats(
    count: Int
  )
}

pub fn count_cats(){
  let sql = "select
  count(*)
from
  cats"
  #(sql, Nil)
}

pub fn count_cats_decoder() -> decode.Decoder(CountCats) {
  use count <- decode.field(0, decode.int)
  decode.success(CountCats(count: ))
}