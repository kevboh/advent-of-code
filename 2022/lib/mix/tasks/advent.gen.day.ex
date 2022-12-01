defmodule Mix.Tasks.Advent.Gen.Day do
  @moduledoc "Task to generate a day solution module: mix advent.gen.day 1"

  use Mix.Task
  import Mix.Generator

  @shortdoc "Generates an Advent of Code day solution module."
  @impl Mix.Task
  def run([day]) do
    path = "lib/days/day#{day}.ex"

    if File.exists?(path) do
      Mix.shell().info([:yellow, "* Skipping ", :reset, path, " (already exists)"])
    else
      Mix.shell().info([:green, "* Creating ", :reset, path])
      File.write(path, day_template(day: day))
    end
  end

  embed_template(:day, """
  defmodule AdventOfCode.Days.Day<%= @day %> do
    import AdventOfCode

    def part1 do
      "not implemented"
    end

    def part2 do
      "not implemented"
    end

    defp input do
      read_input(<%= @day %>)
    end
  end
  """)
end
