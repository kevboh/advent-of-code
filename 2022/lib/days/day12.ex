defmodule AdventOfCode.Days.Day12 do
  import AdventOfCode

  def part1 do
    {nodes, start, target} = input()

    find_path(nodes, start, target)
  end

  def part2 do
    {nodes, _, target} = input()

    nodes
    |> Map.to_list()
    |> Enum.filter(fn {_, v} -> v == ?a end)
    |> Enum.map(&elem(&1, 0))
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn pos -> find_path(nodes, pos, target) end)
    |> Enum.to_list()
    |> Enum.min()
  end

  defp input do
    read_input(12)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_charlist/1)
    |> Stream.with_index()
    |> Enum.to_list()
    |> Enum.reduce({%{}, nil, nil}, fn {list, col}, acc ->
      list
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {c, row}, {nodes, start, target} ->
        start = if(c == ?S, do: {row, col}, else: start)
        target = if(c == ?E, do: {row, col}, else: target)
        {Map.put(nodes, {row, col}, val(c)), start, target}
      end)
    end)
  end

  defp val(c) when c == ?S, do: ?a
  defp val(c) when c == ?E, do: ?z
  defp val(c), do: c

  defp neighbors(nodes, {x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.filter(fn k -> not is_nil(nodes[k]) and nodes[k] <= nodes[{x, y}] + 1 end)
  end

  # I realize I have a version of dijkstra's from 2021, but I learn through repetition, so.
  defp find_path(nodes, start, target) do
    find_path(nodes, MapSet.new(), %{start => 0}, target)
  end

  defp find_path(nodes, unvisited, distances, target) do
    current =
      distances
      |> Map.to_list()
      |> Enum.sort(fn {_, v1}, {_, v2} -> v1 <= v2 end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.find(fn k -> not MapSet.member?(unvisited, k) end)

    case current do
      nil ->
        1_000_000

      ^target ->
        distances[current]

      _ ->
        dist = distances[current] + 1

        distances =
          neighbors(nodes, current)
          |> Enum.reduce(distances, fn pos, acc ->
            Map.update(acc, pos, dist, fn d -> min(d, dist) end)
          end)

        find_path(nodes, MapSet.put(unvisited, current), distances, target)
    end
  end
end
