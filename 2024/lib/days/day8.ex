defmodule AdventOfCode.Days.Day8 do
  use AdventOfCode

  def part1 do
    solve(&antinodes_one/3)
  end

  def part2 do
    solve(&antinodes_two/3)
  end

  defp solve(antinodes_fn) do
    {map, size} =
      input()

    map
    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    |> Enum.flat_map(fn {_, points} ->
      combinations(points)
      |> Enum.flat_map(fn {p1, p2} ->
        antinodes_fn.(p1, p2, size)
      end)
    end)
    |> Enum.filter(&Grid.contains?(size, &1))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp antinodes_one({x1, y1}, {x2, y2}, _size) do
    dx = x2 - x1
    dy = y2 - y1

    [{x1 - dx, y1 - dy}, {x2 + dx, y2 + dy}]
  end

  defp antinodes_two({x1, y1} = p1, {x2, y2} = p2, size) do
    dx = x2 - x1
    dy = y2 - y1

    iterate_antinodes(p1, -dx, -dy, size) ++ iterate_antinodes(p2, dx, dy, size)
  end

  defp iterate_antinodes(p, dx, dy, size) do
    Stream.iterate(p, fn {x, y} -> {x + dx, y + dy} end)
    |> Enum.take_while(&Grid.contains?(size, &1))
  end

  defp input do
    input = Input.read(8)

    m =
      Grid.to_map(input)
      |> Enum.reject(fn {_, v} -> v == "." end)

    size = Grid.size(input)

    {m, size}
  end
end
