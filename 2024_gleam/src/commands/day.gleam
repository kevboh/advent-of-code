import days/day01
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import glint
import simplifile
import tempo/date
import util/days

fn day_flag() -> glint.Flag(String) {
  glint.string_flag("day")
  |> glint.flag_default(
    date.current_local() |> date.get_day() |> int.to_string(),
  )
  |> glint.flag_help("Day to run")
}

fn parts_flag() -> glint.Flag(List(String)) {
  glint.strings_flag("parts")
  |> glint.flag_default(["1", "2"])
  |> glint.flag_help("Part(s) to run")
}

pub fn run() -> glint.Command(Nil) {
  use <- glint.command_help("Runs the part(s) for a day.")
  use day <- glint.flag(day_flag())
  use parts <- glint.flag(parts_flag())
  use _, _args, flags <- glint.command()

  let assert Ok(day) = day(flags)
  let assert Ok(parts) = parts(flags)

  let day = days.pad_day(day)

  let result =
    parts
    |> list.map(fn(part) { run_day_part(day, part) })
    |> string.join(", ")

  io.println(result)

  Nil
}

fn run_day_part(day: String, part: String) -> String {
  let input_file = "inputs/" <> day <> ".txt"
  let assert Ok(input) = simplifile.read(input_file)
  let input = string.trim(input)

  case day, part {
    "01", "1" -> day01.part1(input)
    "01", "2" -> day01.part2(input)
    _, _ -> "Day not implemented"
  }
}
