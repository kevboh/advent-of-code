defmodule AdventOfCode.Days.Day10 do
  use AdventOfCode

  def part1 do
    sum_trails(&Enum.uniq/1)
  end

  def part2 do
    sum_trails()
  end

  defp sum_trails(fun \\ & &1) do
    grid = input()

    grid.map
    |> Enum.filter(fn {_, v} -> v == 0 end)
    |> Enum.map(fn {trailhead, _} ->
      count_trails(grid, trailhead)
      |> fun.()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp count_trails(grid, point, value \\ 0)

  defp count_trails(_, point, 9) do
    [point]
  end

  defp count_trails(grid, {x, y}, value) do
    Grid.neighbors(grid, {x, y})
    |> Enum.filter(fn {_, v} -> v == value + 1 end)
    |> Enum.flat_map(fn {point, _} -> count_trails(grid, point, value + 1) end)
  end

  defp input do
    Input.read(10)
    |> Grid.from_stream(&String.to_integer/1)
  end
end
