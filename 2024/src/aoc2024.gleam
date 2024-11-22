import argv
import commands/input
import glint

pub fn main() {
  glint.new()
  |> glint.with_name("aoc2024")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: ["input"], do: input.fetch())
  |> glint.run(argv.load().arguments)
}
