defmodule AdventOfCode.Days.Day8 do
  import AdventOfCode

  def part1 do
    input()
    |> Map.values()
    |> Enum.map(&elem(&1, 1))
    |> Enum.filter(&(&1 == :visible))
    |> length()
  end

  def part2 do
    grid = input()

    grid
    |> Map.to_list()
    |> Enum.map(fn {pos, {tree, _}} -> score(grid, tree, pos) end)
    |> Enum.max()
  end

  defp input do
    read_input(8)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.with_index()
    |> Enum.reduce({%{}, 0, 0}, &reduce/2)
    |> walk_spiral()
    |> elem(0)
  end

  defp reduce({line, row}, acc = {_, _, height}) do
    {g, w, _} =
      line
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {tree, col}, {grid, width, _} ->
        {Map.put(grid, {col, row}, {tree, :unvisited}), max(col, width), height}
      end)

    {g, w, max(row, height)}
  end

  defp walk_spiral({grid, width, height}, {x, y} \\ {0, 0}, {sx, sy} \\ {1, 0}) do
    case Map.get(grid, {x, y}) do
      {tree, :unvisited} ->
        grid = Map.put(grid, {x, y}, {tree, sight_tree(grid, tree, {x, y})})
        walk_spiral({grid, width, height}, {x + sx, y + sy}, {sx, sy})

      _ ->
        {x, y} = {x - sx, y - sy}

        if x == width / 2 and y == height / 2 do
          {grid, width, height}
        else
          {sx, sy} =
            case {sx, sy} do
              {1, 0} -> {0, 1}
              {0, 1} -> {-1, 0}
              {-1, 0} -> {0, -1}
              {0, -1} -> {1, 0}
            end

          walk_spiral({grid, width, height}, {x + sx, y + sy}, {sx, sy})
        end
    end
  end

  defp sight_tree(grid, tree, {x, y}) do
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    |> Enum.map(&sight_tree(grid, tree, {x, y}, &1))
    |> Enum.any?(&(&1 == :visible))
    |> if(do: :visible, else: :invisible)
  end

  defp sight_tree(grid, tree, {x, y}, {sx, sy}, distance \\ 1) do
    case Map.get(grid, {x + sx * distance, y + sy * distance}) do
      {t, _} when t >= tree -> :invisible
      nil -> :visible
      _ -> sight_tree(grid, tree, {x, y}, {sx, sy}, distance + 1)
    end
  end

  defp score(grid, tree, {x, y}) do
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    |> Enum.map(&score(grid, tree, {x, y}, &1))
    |> Enum.product()
  end

  defp score(grid, tree, {x, y}, {sx, sy}, distance \\ 1) do
    case Map.get(grid, {x + sx * distance, y + sy * distance}) do
      {t, _} when t >= tree -> distance
      nil -> distance - 1
      _ -> score(grid, tree, {x, y}, {sx, sy}, distance + 1)
    end
  end
end
