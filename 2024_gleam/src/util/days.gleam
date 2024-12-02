import gleam/string

pub fn pad_day(day: String) -> String {
  case string.length(day) {
    1 -> "0" <> day
    _ -> day
  }
}
