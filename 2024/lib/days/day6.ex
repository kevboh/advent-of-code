defmodule AdventOfCode.Days.Day6 do
  import AdventOfCode

  alias AdventOfCode.Helpers.Grid

  def part1 do
    {start, obstacles, size} = grid()

    {:ok, res} = walk_one(start, :up, obstacles, size, MapSet.new([{start, :up}]))

    res
  end

  def part2 do
    {start, obstacles, {w, h} = size} = grid()

    # This is naive and I no longer care.
    # I tried a bunch of other things, e.g.:
    # - While walking, simulate out an obstacle in front of you at every step.
    #   Count a loop as striking any obstacle from the direction you've struck it before.
    #   This overestimated.
    # - While walking, simulate out an obstacle in front of you at every step.
    #   Count a loop as visiting any position+direction pair you've visited before.
    #   This also overestimated.
    # Doing the latter check but for every possible obstacle position worked, which
    # is silly, and can certainly be sped up (only check where the guard can walk,
    # perhaps project out other looping obstacles once you find one on a line),
    # but I'm over it.
    for x <- 0..(w - 1), y <- 0..(h - 1), reduce: 0 do
      acc ->
        obstacles = MapSet.put(obstacles, {x, y})

        case walk_one(start, :up, obstacles, size, MapSet.new([{start, :up}])) do
          {:error, :loop} -> acc + 1
          _ -> acc
        end
    end
  end

  defp walk_one({x, y} = pos, direction, _, {w, h}, visited)
       when x < 0 or x >= w or y < 0 or y >= h do
    visited =
      visited
      |> MapSet.delete({pos, direction})
      |> Enum.map(&elem(&1, 0))
      |> Enum.uniq()
      |> Enum.count()

    {:ok, visited}
  end

  defp walk_one(pos, direction, obstacles, size, visited) do
    next = step(pos, direction)

    case {MapSet.member?(obstacles, next), MapSet.member?(visited, {next, direction})} do
      {_, true} ->
        {:error, :loop}

      {false, _} ->
        walk_one(next, direction, obstacles, size, MapSet.put(visited, {next, direction}))

      {true, _} ->
        walk_one(pos, turn(direction), obstacles, size, visited)
    end
  end

  defp step({x, y}, :up), do: {x, y - 1}
  defp step({x, y}, :right), do: {x + 1, y}
  defp step({x, y}, :down), do: {x, y + 1}
  defp step({x, y}, :left), do: {x - 1, y}

  defp turn(:up), do: :right
  defp turn(:right), do: :down
  defp turn(:down), do: :left
  defp turn(:left), do: :up

  defp grid do
    input = read_input(6)

    {obstacles, [{start, _}]} =
      Grid.to_map(input)
      |> Enum.reject(fn {_, c} -> c == "." end)
      |> Enum.split_with(fn {_, c} -> c == "#" end)

    {
      start,
      Enum.map(obstacles, &elem(&1, 0)) |> MapSet.new(),
      Grid.size(input)
    }
  end
end
