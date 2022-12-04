defmodule AdventOfCode.Days.Day4 do
  import AdventOfCode

  def part1 do
    input()
    |> Stream.filter(&contains?/1)
    |> Enum.count()
  end

  def part2 do
    input()
    |> Stream.filter(&(not disjoint?(&1)))
    |> Enum.count()
  end

  defp input do
    read_input(4)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&ranges/1)
  end

  defp ranges(line) do
    to_range = fn raw ->
      [s, e] = String.split(raw, "-")
      Range.new(String.to_integer(s), String.to_integer(e))
    end

    line
    |> String.split(",")
    |> Enum.map(to_range)
  end

  defp contains?([rs..re, ls..le]) do
    (rs <= ls && re >= le) || (ls <= rs && le >= re)
  end

  defp disjoint?([r, l]), do: Range.disjoint?(r, l)
end
