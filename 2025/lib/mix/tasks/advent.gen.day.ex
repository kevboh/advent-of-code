defmodule Mix.Tasks.Advent.Gen.Day do
  @moduledoc "Task to generate a day solution module: mix advent.gen.day 1"

  use Mix.Task
  import Mix.Generator

  @shortdoc "Generates an Advent of Code day solution module."
  @impl Mix.Task
  def run([day]) do
    Mix.Generator.create_file("lib/days/day#{day}.ex", day_template(day: day))
  end

  embed_template(:day, """
  defmodule AdventOfCode.Days.Day<%= @day %> do
    use AdventOfCode

    def part1 do
      "not implemented"
    end

    def part2 do
      "not implemented"
    end

    defp input do
      stream_day(<%= @day %>)
    end
  end
  """)
end
