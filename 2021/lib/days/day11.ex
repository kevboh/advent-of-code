defmodule AdventOfCode.Days.Day11 do
  import AdventOfCode

  @grid_length 10
  @flash_state_key "flash_count"

  def part1 do
    grid =
      for _step_count <- 1..100, reduce: get_grid() do
        g ->
          step(g)
      end

    grid[@flash_state_key]
  end

  def part2 do
    p2_step(get_grid())
  end

  defp input do
    read_input(11)
  end

  defp get_grid do
    for {row_str, row} <- Enum.with_index(input()),
        {v, col} <- row_str |> String.graphemes() |> Enum.with_index(),
        reduce: %{} do
      g ->
        Map.put(g, {row, col}, String.to_integer(v))
    end
  end

  defp step(grid) do
    # increment all octopi by 1
    grid = Map.map(grid, fn {k, v} -> if k != @flash_state_key, do: v + 1, else: v end)

    # check for any > 9s, add to set, recurse
    {grid, flashed} =
      grid
      |> Map.to_list()
      |> Enum.filter(fn {k, v} -> v > 9 && k != @flash_state_key end)
      |> Enum.map(fn {k, _v} -> k end)
      |> Enum.reduce({grid, MapSet.new()}, fn rc, {g, f} ->
        flash(g, rc, f)
      end)

    # set all flashed to 0
    grid =
      for i <- flashed |> MapSet.to_list(),
          into: grid,
          do: {i, 0}

    grid |> Map.update(@flash_state_key, 0, &(&1 + MapSet.size(flashed)))
  end

  defp flash(grid, {row, col}, flashed) do
    # check at this position
    if grid[{row, col}] > 9 && !MapSet.member?(flashed, {row, col}) do
      flashed = MapSet.put(flashed, {row, col})

      neighbors({row, col})
      |> Enum.reduce({grid, flashed}, fn n, {g, f} ->
        g = Map.update!(g, n, &(&1 + 1))
        flash(g, n, f)
      end)
    else
      {grid, flashed}
    end
  end

  defp neighbors({row, col}) do
    for r <- max(0, row - 1)..min(@grid_length - 1, row + 1),
        c <- max(0, col - 1)..min(@grid_length - 1, col + 1),
        into: [],
        do: {r, c}
  end

  defp p2_step(grid, count \\ 0) do
    count = count + 1
    before = grid[@flash_state_key]
    grid = step(grid)

    if before != nil && grid[@flash_state_key] - before == 100 do
      count
    else
      p2_step(grid, count)
    end
  end
end
