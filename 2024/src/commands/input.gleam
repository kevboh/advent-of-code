import envoy
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/string
import glint
import simplifile
import tempo/date

fn year_flag() -> glint.Flag(String) {
  glint.string_flag("year")
  |> glint.flag_default(
    date.current_local() |> date.get_year() |> int.to_string(),
  )
  |> glint.flag_help("Year to fetch input for")
}

pub fn fetch() -> glint.Command(Nil) {
  use <- glint.command_help("Fetches the input for the given day.")
  use year <- glint.flag(year_flag())
  use _, args, flags <- glint.command()

  let assert Ok(year) = year(flags)

  let day = case args {
    [] -> {
      let today = date.current_local()
      date.get_day(today)
      |> int.to_string()
    }
    [day, ..] -> day
  }

  let assert Ok(session) = envoy.get("ADVENT_OF_CODE_SESSION")
  let path =
    "inputs/"
    |> string.append(day)
    |> string.append(".txt")

  let url =
    "https://adventofcode.com/"
    |> string.append(year)
    |> string.append("/day/")
    |> string.append(day)
    |> string.append("/input")

  let assert Ok(req) = request.to(url)

  let req = request.prepend_header(req, "Cookie", "session=" <> session)
  let assert Ok(resp) = httpc.send(req)

  let assert Ok(_) = simplifile.write(resp.body, to: path)
  Nil
}
