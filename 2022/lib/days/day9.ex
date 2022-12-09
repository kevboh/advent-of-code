defmodule AdventOfCode.Days.Day9.Accumulator do
  defstruct rope: [], visited: MapSet.new([{0, 0}])

  def make(length) do
    %AdventOfCode.Days.Day9.Accumulator{
      rope: Enum.map(1..length, fn _ -> {0, 0} end)
    }
  end

  def move("U", acc), do: move(acc, {0, 1})
  def move("R", acc), do: move(acc, {1, 0})
  def move("D", acc), do: move(acc, {0, -1})
  def move("L", acc), do: move(acc, {-1, 0})

  def move(acc, d) do
    {rope, tail} = shift(acc.rope, d)
    %{acc | rope: rope, visited: MapSet.put(acc.visited, tail)}
  end

  def shift([{hx, hy} | rest], {x, y}) do
    head = {hx + x, hy + y}
    shift(rest, {hx, hy}, [head])
  end

  def shift([tail | rest], _old, rope = [head | _]) do
    ftail = tail
    tail = move_towards(head, tail)

    case rest do
      [] -> {Enum.reverse([tail | rope]), tail}
      rem -> shift(rem, ftail, [tail | rope])
    end
  end

  defp move_towards({hx, hy}, t = {tx, ty}) do
    {move_x, x} = axis_diff(hx, tx)
    {move_y, y} = axis_diff(hy, ty)

    if move_x or move_y, do: {x, y}, else: t
  end

  defp axis_diff(a, b) when a != b do
    {abs(a - b) > 1, b + trunc(abs(a - b) / (a - b))}
  end

  defp axis_diff(_a, b), do: {false, b}
end

defmodule AdventOfCode.Days.Day9 do
  alias AdventOfCode.Days.Day9.Accumulator

  import AdventOfCode

  def part1 do
    input()
    |> Stream.flat_map(&map/1)
    |> Enum.to_list()
    |> Enum.reduce(Accumulator.make(2), &Accumulator.move/2)
    |> Map.get(:visited)
    |> grid()
    |> MapSet.size()
  end

  def part2 do
    input()
    |> Stream.flat_map(&map/1)
    |> Enum.to_list()
    |> Enum.reduce(Accumulator.make(10), &Accumulator.move/2)
    |> Map.get(:visited)
    |> grid()
    |> MapSet.size()
  end

  defp input do
    read_input(9)
    |> Stream.map(&String.trim/1)
  end

  defp map(<<cmd::binary-size(1), " ", count::binary>>) do
    for _ <- 1..String.to_integer(count), into: [], do: cmd
  end

  defp grid(visited) do
    min_x = visited |> Enum.to_list() |> Enum.map(&elem(&1, 0)) |> Enum.min()
    max_x = visited |> Enum.to_list() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    min_y = visited |> Enum.to_list() |> Enum.map(&elem(&1, 1)) |> Enum.min()
    max_y = visited |> Enum.to_list() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for y <- max_y..min_y do
      l =
        for x <- min_x..max_x,
            into: "",
            do: if(MapSet.member?(visited, {x, y}), do: <<"#">>, else: <<".">>)

      IO.puts(l)
    end

    visited
  end
end
