defmodule AdventOfCode.Days.Day14 do
  import AdventOfCode

  def part1 do
    g = input()
    besand(g, {:p1, fall_y(g)})
  end

  def part2 do
    g = input()
    besand(g, {:p2, fall_y(g)})
  end

  defp input do
    read_input(14)
    |> Stream.map(fn s ->
      s
      |> String.trim()
      |> String.split(" -> ")
      |> Enum.map(fn seg ->
        seg
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
    end)
    |> Enum.to_list()
    |> Enum.reduce(%{}, &reduce/2)
  end

  defp reduce(line, grid) do
    Enum.zip(line, tl(line))
    |> Enum.reduce(grid, fn {{x1, y1}, {x2, y2}}, acc ->
      for x <- x1..x2, y <- y1..y2, reduce: acc do
        acc -> Map.put(acc, {x, y}, :rock)
      end
    end)
  end

  defp fall_y(grid) do
    grid
    |> Map.keys()
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  defp besand(grid, limit) do
    case drop_sand(grid, limit) do
      {:landed, grid} ->
        besand(grid, limit)

      {:full, grid} ->
        grid
        |> Map.values()
        |> Enum.filter(&(&1 == :sand))
        |> Enum.count()
    end
  end

  defp drop_sand(grid, limit) do
    drop_sand(grid, {500, -1}, {500, 0}, limit)
  end

  defp drop_sand(grid, _, {_, y}, {:p1, limit}) when y > limit, do: {:full, grid}

  defp drop_sand(grid, p, {_, y2}, {:p2, limit}) when y2 == limit + 2,
    do: {:landed, Map.put(grid, p, :sand)}

  # vertical down, unblocked
  defp drop_sand(grid, {x, y1}, q = {x, y2}, limit)
       when not is_map_key(grid, q) and y2 == y1 + 1 do
    drop_sand(grid, q, {x, y2 + 1}, limit)
  end

  # vertical down, blocked
  defp drop_sand(grid, p = {x, y1}, q = {x, y2}, limit)
       when is_map_key(grid, q) and y2 == y1 + 1 do
    drop_sand(grid, p, {x - 1, y2}, limit)
  end

  # down + left, unblocked
  defp drop_sand(grid, {x1, y1}, q = {x2, y2}, limit)
       when not is_map_key(grid, q) and y2 == y1 + 1 and x2 == x1 - 1 do
    drop_sand(grid, q, {x2, y2 + 1}, limit)
  end

  # down + left, blocked
  defp drop_sand(grid, p = {x1, y1}, q = {x2, y2}, limit)
       when is_map_key(grid, q) and y2 == y1 + 1 and x2 == x1 - 1 do
    drop_sand(grid, p, {x1 + 1, y2}, limit)
  end

  # down + right, unblocked
  defp drop_sand(grid, {x1, y1}, q = {x2, y2}, limit)
       when not is_map_key(grid, q) and y2 == y1 + 1 and x2 == x1 + 1 do
    drop_sand(grid, q, {x2, y2 + 1}, limit)
  end

  # down + right, blocked
  defp drop_sand(grid, p = {x1, y1}, q = {x2, y2}, _limit)
       when is_map_key(grid, q) and y2 == y1 + 1 and x2 == x1 + 1 do
    case p do
      {500, 0} ->
        {:full, Map.put(grid, p, :sand)}

      _ ->
        {:landed, Map.put(grid, p, :sand)}
    end
  end

  defp print(grid) do
    min_x = grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min()
    max_x = grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    min_y = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min()
    max_y = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for y <- min_y..max_y do
      l =
        for x <- min_x..max_x, into: "" do
          case grid[{x, y}] do
            :sand -> <<"o">>
            :rock -> <<"#">>
            _ -> <<".">>
          end
        end

      IO.puts(l)
    end

    grid
  end
end
