import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

pub fn part1(input: String) -> String {
  let assert [team_one, team_two] = parse(input)

  let team_one = list.sort(team_one, by: int.compare)
  let team_two = list.sort(team_two, by: int.compare)

  list.zip(team_one, team_two)
  |> list.map(fn(t) { int.absolute_value(t.0 - t.1) })
  |> sum_and_string
}

pub fn part2(input: String) -> String {
  let assert [team_one, team_two] = parse(input)

  let increment = fn(x) {
    case x {
      Some(i) -> i + 1
      None -> 1
    }
  }

  let lookup =
    team_two
    |> list.fold(dict.new(), fn(a, i) { dict.upsert(a, i, increment) })

  team_one
  |> list.map(fn(i) {
    case dict.get(lookup, i) {
      Ok(r) -> i * r
      Error(_) -> 0
    }
  })
  |> sum_and_string
}

fn parse(input: String) -> List(List(Int)) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(l) {
    string.split(l, "   ")
    |> list.map(fn(s) { s |> int.parse |> result.unwrap(0) })
  })
  |> list.transpose
}

fn sum_and_string(l: List(Int)) -> String {
  l
  |> list.fold(0, int.add)
  |> int.to_string
}
