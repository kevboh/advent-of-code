defmodule AdventOfCode.Days.Day12 do
  import AdventOfCode

  def part1 do
    follow(connections(), "start")
    |> Enum.map(&Enum.join(&1, ","))
    |> MapSet.new()
    |> MapSet.to_list()
    |> length()
  end

  def part2 do
    follow(connections(), "start", 2)
    |> Enum.map(&Enum.join(&1, ","))
    |> MapSet.new()
    |> MapSet.to_list()
    |> length()
  end

  defp input do
    read_input(12)
  end

  defp connections() do
    input()
    |> Enum.map(fn s ->
      [from, to] = String.split(s, "-")
      {from, to}
    end)
    |> Enum.reduce(%{}, fn {from, to}, acc ->
      acc
      |> Map.update(from, MapSet.new([to]), fn t -> MapSet.put(t, to) end)
      |> Map.update(to, MapSet.new([from]), fn t -> MapSet.put(t, from) end)
    end)
    |> Map.map(fn {_k, v} -> MapSet.to_list(v) end)
  end

  defp follow(conn, from, max_small_visits \\ 1, path \\ []) do
    path = [from | path]

    if from == "end" do
      [path |> Enum.reverse()]
    else
      visits = path |> Enum.frequencies()

      can_multi_visit =
        visits
        |> Map.to_list()
        |> Enum.filter(fn {k, v} -> String.match?(k, ~r/[a-z]+/) && v > 1 end)
        |> Enum.empty?()

      max_small_visits = if can_multi_visit, do: max_small_visits, else: 1

      to_visit =
        conn[from]
        |> Enum.filter(fn t ->
          can_visit(t, visits, max_small_visits)
        end)

      to_visit |> Enum.map(fn v -> follow(conn, v, max_small_visits, path) end) |> Enum.concat()
    end
  end

  defp can_visit(to, visits, max_visits) do
    c = visits[to]
    String.match?(to, ~r/[A-Z]+/) || c == nil || (to not in ["start", "end"] && c < max_visits)
  end
end
