defmodule AdventOfCode.Days.Day4 do
  @moduledoc false
  use AdventOfCode

  alias AdventOfCode.Grid

  def part1 do
    grid = input()
    Enum.count(grid.map, fn {point, v} -> v and count_adjacent(grid, point) < 4 end)
  end

  def part2 do
    collect_rolls(input())
  end

  defp count_adjacent(grid, {x, y}) do
    grid
    |> Grid.neighbors({x, y}, diagonals: true)
    |> Enum.count(fn {_, v} -> v end)
  end

  defp collect_rolls(grid, acc \\ 0) do
    rolls =
      grid.map
      |> Enum.filter(fn {point, v} -> v and count_adjacent(grid, point) < 4 end)
      |> Enum.map(fn {k, _} -> k end)

    case rolls do
      [] ->
        acc

      rolls ->
        grid = Grid.update(grid, rolls, false)
        collect_rolls(grid, acc + Enum.count(rolls))
    end
  end

  defp input do
    4
    |> stream_day()
    |> Grid.from_stream(&(&1 == "@"))
  end
end
