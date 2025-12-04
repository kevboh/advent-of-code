defmodule Mix.Tasks.Advent.Solve do
  @shortdoc "Solves an Advent of Code puzzle."
  @moduledoc "The solve mix task, e.g. mix solve 1"

  use Mix.Task

  @impl Mix.Task
  def run(day_num) do
    day = String.to_atom("Days.Day#{day_num}")
    IO.puts("Solving day #{day_num}…")
    part1 = apply(Module.concat(AdventOfCode, day), :part1, [])
    IO.puts("Part 1: #{part1}")
    part2 = apply(Module.concat(AdventOfCode, day), :part2, [])
    IO.puts("Part 2: #{part2}")
  end
end
