defmodule AdventOfCode.Days.Day9 do
  import AdventOfCode

  def part1 do
    i = input()
    grid_width = i |> hd() |> String.length()
    grid_height = i |> length()

    make_grid(i)
    |> minima({grid_width, grid_height})
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  def part2 do
    i = input()
    grid_width = i |> hd() |> String.length()
    grid_height = i |> length()

    grid = make_grid(i)
    mins = minima(grid, {grid_width, grid_height})

    mins
    |> Enum.map(fn {loc, _} -> basin_size(grid, {grid_width, grid_height}, loc) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(&(&1 > &2))
    |> Enum.take(3)
    |> Enum.product()
  end

  defp input do
    read_input(9)
  end

  defp make_grid(i) do
    for {row, row_index} <- Enum.with_index(i),
        {char, col_index} <- Enum.with_index(String.graphemes(row)),
        reduce: %{} do
      acc ->
        Map.put(acc, {row_index, col_index}, String.to_integer(char))
    end
  end

  defp neighbors(grid, {grid_width, grid_height}, {row, col}) do
    top = if row > 0, do: [{{row - 1, col}, grid[{row - 1, col}]}], else: []
    left = if col > 0, do: [{{row, col - 1}, grid[{row, col - 1}]}], else: []
    right = if col < grid_width - 1, do: [{{row, col + 1}, grid[{row, col + 1}]}], else: []
    bottom = if row < grid_height - 1, do: [{{row + 1, col}, grid[{row + 1, col}]}], else: []

    top ++ left ++ right ++ bottom
  end

  defp minima(grid, {grid_width, grid_height}) do
    grid
    |> Enum.to_list()
    |> Enum.filter(fn {{row, col}, v} ->
      Enum.all?(neighbors(grid, {grid_width, grid_height}, {row, col}), fn {_, n} -> v < n end)
    end)
  end

  defp basin_size(grid, grid_dims, {row, col}, seen \\ MapSet.new()) do
    # get value at location
    seen = MapSet.put(seen, {row, col})
    v = grid[{row, col}]

    # get neighbors
    neighbors = neighbors(grid, grid_dims, {row, col})

    # filter out ones smaller than us
    new_neighbors =
      neighbors
      |> Enum.filter(fn {loc, nv} -> nv > v && nv != 9 && !MapSet.member?(seen, loc) end)

    # we have to search depth-first to avoid repeat-counting neighbors
    new_neighbors |> Enum.reduce(seen, fn {n, _}, acc -> basin_size(grid, grid_dims, n, acc) end)
  end
end
