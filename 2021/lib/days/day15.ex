defmodule AdventOfCode.Days.Day15 do
  import AdventOfCode

  @max_cost 9

  # I could use https://hexdocs.pm/libgraph/Graph.Pathfinding.html but I won't.
  def part1 do
    run(1)
  end

  def part2 do
    run(5)
  end

  defp run(modifier) do
    {grid, width, height} = input()

    cost_at = fn {x, y} ->
      x_mod = div(x, width)
      y_mod = div(y, height)

      x1 = rem(x, width)
      y1 = rem(y, height)

      cost = grid[{x1, y1}] + x_mod + y_mod
      r = rem(cost, @max_cost)
      if r == 0, do: @max_cost, else: r
    end

    mod_width = width * modifier
    mod_height = height * modifier

    dijkstras(cost_at, {mod_width, mod_height}, {mod_width - 1, mod_height - 1}, {0, 0})
  end

  # A very, very naive Dijkstra's implementation.
  # Tried a few priority queues, none of them fit without work.
  defp dijkstras(
         cost_at,
         grid_dims,
         destination,
         current,
         visited \\ MapSet.new(),
         distances \\ %{}
       ) do
    # IO.inspect(current, label: "visiting")

    # get the cost to get to this node. if nil, we're at the start, which costs 0.
    current_cost = distances[current]
    distances = Map.delete(distances, current)
    current_cost = if current_cost == nil, do: 0, else: current_cost

    distances =
      neighbors(grid_dims, current)
      |> Enum.reject(fn n -> MapSet.member?(visited, n) end)
      |> Enum.reduce(distances, fn n, acc ->
        distance = acc[n]
        cost = cost_at.(n)

        if distance == nil || current_cost + cost < distance do
          Map.put(acc, n, current_cost + cost)
        else
          acc
        end
      end)

    visited = MapSet.put(visited, current)

    {next, cost} =
      distances
      |> Map.to_list()
      |> Enum.sort(fn {_, a}, {_, b} -> a < b end)
      |> hd()

    if next == destination do
      cost
    else
      dijkstras(cost_at, grid_dims, destination, next, visited, distances)
    end
  end

  defp neighbors({grid_width, grid_height}, {row, col}) do
    top = if row > 0, do: [{row - 1, col}], else: []
    left = if col > 0, do: [{row, col - 1}], else: []
    right = if col < grid_width - 1, do: [{row, col + 1}], else: []
    bottom = if row < grid_height - 1, do: [{row + 1, col}], else: []

    top ++ left ++ right ++ bottom
  end

  defp input do
    i = read_input(15)

    height = length(i)
    width = i |> hd() |> String.length()

    g =
      for {row, r} <- Enum.with_index(i),
          {v, c} <- row |> String.graphemes() |> Enum.with_index(),
          into: %{},
          do: {{r, c}, String.to_integer(v)}

    {g, width, height}
  end
end
