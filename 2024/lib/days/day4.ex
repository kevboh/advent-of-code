defmodule AdventOfCode.Days.Day4 do
  use AdventOfCode

  def part1 do
    input()
    |> sum_with(&xmas?/3)
  end

  def part2 do
    input()
    |> sum_with(&x_mas?/3)
  end

  def sum_with({map, {mx, my}}, predicate) do
    for x <- 0..mx, y <- 0..my, into: [] do
      predicate.(map, Map.get(map, {x, y}), {x, y})
    end
    |> Enum.sum()
  end

  defp xmas?(map, "X", {x, y}) do
    for dx <- -1..1, dy <- -1..1 do
      "XMAS" ==
        0..3
        |> Enum.map(&{x + dx * &1, y + dy * &1})
        |> Enum.map(&Map.get(map, &1, ""))
        |> Enum.join()
    end
    |> Enum.count(& &1)
  end

  defp xmas?(_, _, _), do: 0

  defp x_mas?(map, "A", {x, y}) do
    # top-left, bottom-right
    # top-right, bottom-left
    case {Map.get(map, {x - 1, y - 1}), Map.get(map, {x + 1, y + 1}),
          Map.get(map, {x + 1, y - 1}), Map.get(map, {x - 1, y + 1})} do
      {"M", "S", "M", "S"} -> 1
      {"S", "M", "S", "M"} -> 1
      {"S", "M", "M", "S"} -> 1
      {"M", "S", "S", "M"} -> 1
      {_, _, _, _} -> 0
    end
  end

  defp x_mas?(_, _, _), do: 0

  defp input do
    lines =
      Input.read(4)
      |> Stream.map(&(&1 |> String.trim() |> String.codepoints() |> Enum.with_index()))
      |> Enum.with_index()

    max_y = Enum.count(lines)
    max_x = lines |> hd() |> elem(0) |> Enum.count()

    map =
      for {line, y} <- lines, {char, x} <- line, into: %{} do
        {{x, y}, char}
      end

    {map, {max_x, max_y}}
  end
end
