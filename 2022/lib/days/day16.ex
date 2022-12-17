defmodule AdventOfCode.Days.Day16.Parser do
  import NimbleParsec

  def valve, do: ascii_string([?A..?Z], 2)

  def plural(c, str) do
    c
    |> ignore(string(str))
    |> ignore(optional(string("s")))
    |> ignore(string(" "))
  end

  def line do
    ignore(string("Valve "))
    |> concat(valve())
    |> ignore(string(" has flow rate="))
    |> integer(min: 1)
    |> plural("; tunnel")
    |> plural("lead")
    |> ignore(string("to "))
    |> plural("valve")
    |> repeat(
      valve()
      |> optional(ignore(string(", ")))
    )
  end
end

defmodule AdventOfCode.Days.Day16 do
  import AdventOfCode
  import NimbleParsec

  defparsec(:valve_line, AdventOfCode.Days.Day16.Parser.line())

  def part1 do
    input()
    |> hops(%{}, "AA")
    |> IO.inspect()

    search(input())
    |> IO.inspect()

    # res = search(input())
    # IO.inspect(res)

    "not implemented"
  end

  def part2 do
    "not implemented"
  end

  defp input do
    read_input("16a")
    |> Stream.map(&String.trim/1)
    |> Enum.reduce(%{}, &rd/2)
  end

  defp rd(line, acc) do
    {:ok, [name, flow | tunnels], _, _, _, _} = valve_line(line)

    Map.put(acc, name, %{flow: flow, tunnels: tunnels})
  end

  def search(graph), do: search(graph, %{}, "AA", 30, 0)

  def search(graph, memo, at, minutes, total) do
    # start at AA
    # get hops from AA
    # map each to flow * (30 - hops - 1)
    # choose highest, add to total, move to there, subtract hops - 1 from minutes

    {at_hops, memo} = hops(graph, memo, at)

    avail =
      at_hops
      |> Map.to_list()
      |> Enum.map(fn {node, hops} ->
        cost = hops + 1
        score = graph[node][:flow] * (minutes - cost)
        {node, score, cost}
      end)
      |> Enum.filter(fn {_, s, _} -> s > 0 end)
      |> Enum.sort(fn {_, a, _}, {_, b, _} -> a > b end)

    case avail do
      [{next, score, cost} | _] ->
        IO.puts("Turned on #{next} at #{minutes - cost} to generate #{total + score}")
        graph = put_in(graph[next][:flow], 0)
        search(graph, memo, next, minutes - cost, total + score)

      _ ->
        total
    end
  end

  def hops(graph, memo, from) do
    if memo[from] do
      {memo[from], memo}
    else
      h = do_hops(graph, from, MapSet.new(Map.keys(graph)), Map.put(%{}, from, 0))
      {h, Map.put(memo, from, h)}
    end
  end

  defp do_hops(graph, at, unvisited, distances) do
    neighbors =
      graph[at][:tunnels]
      |> Enum.filter(&MapSet.member?(unvisited, &1))

    cd = distances[at]

    distances =
      for n <- neighbors, reduce: distances do
        acc ->
          case distances[n] do
            nil -> Map.put(acc, n, cd + 1)
            x when x > cd + 1 -> Map.put(acc, n, cd + 1)
            _ -> acc
          end
      end

    unvisited = MapSet.delete(unvisited, at)

    next =
      MapSet.to_list(unvisited)
      |> Enum.map(&{&1, distances[&1]})
      |> Enum.reject(&(elem(&1, 1) == nil))
      |> Enum.sort(fn a, b -> elem(a, 1) < elem(b, 1) end)

    # IO.inspect(next)

    case next do
      [{to, _} | _] ->
        do_hops(graph, to, unvisited, distances)

      _ ->
        distances
    end
  end

  # defp search(graph) do
  #   search(graph, MapSet.new(), "AA", 30, 0, [])
  # end

  # defp search(_, _, _, 1, pressure, path), do: [{pressure, path}]

  # defp search(graph, opened, at, minute, pressure, path) do
  #   # traversal options = connected nodes + turning on value
  #   # cost for connected nodes = 1
  #   # cost for turning on value = flow * remaining minutes - 1
  #   opened_here = not MapSet.member?(opened, at)
  #   here = graph[at]
  #   next = minute - 1
  #   IO.inspect(path, label: "minute #{minute}")

  #   if MapSet.size(opened) == map_size(graph) do
  #     []
  #   else
  #     b =
  #       if not opened_here and here[:flow] > 0 do
  #         p = here[:flow] * next
  #         search(graph, MapSet.put(opened, at), at, next, pressure + p, [at | path])
  #       else
  #         []
  #       end

  #     t =
  #       here[:tunnels]
  #       |> Enum.flat_map(fn t ->
  #         search(graph, opened, t, next, pressure, [at | path])
  #       end)

  #     t ++ b
  #   end
  # end
end
