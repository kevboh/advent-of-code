defmodule AdventOfCode.Days.Day22.Cube do
  defstruct [:x, :y, :z]

  def new(%{
        "minx" => minx,
        "maxx" => maxx,
        "miny" => miny,
        "maxy" => maxy,
        "minz" => minz,
        "maxz" => maxz
      }) do
    %AdventOfCode.Days.Day22.Cube{
      x: minx..maxx,
      y: miny..maxy,
      z: minz..maxz
    }
  end

  def intersects?(l, r) do
    !Range.disjoint?(l.x, r.x) && !Range.disjoint?(l.y, r.y) && !Range.disjoint?(l.z, r.z)
  end

  def intersection(l, r) do
    if !intersects?(l, r) do
      nil
    else
      x = max(l.x.first, r.x.first)..min(l.x.last, r.x.last)
      y = max(l.y.first, r.y.first)..min(l.y.last, r.y.last)
      z = max(l.z.first, r.z.first)..min(l.z.last, r.z.last)
      %AdventOfCode.Days.Day22.Cube{x: x, y: y, z: z}
    end
  end

  def volume(c), do: Range.size(c.x) * Range.size(c.y) * Range.size(c.z)


end

defmodule AdventOfCode.Days.Day22 do
  import AdventOfCode

  alias AdventOfCode.Days.Day22.Cube

  @r ~r/^(?<s>on|off) x=(?<minx>-?\d+)\.\.(?<maxx>-?\d+),y=(?<miny>-?\d+)\.\.(?<maxy>-?\d+),z=(?<minz>-?\d+)\.\.(?<maxz>-?\d+)/

  def part1 do
    initialization = %Cube{x: -50..50, y: -50..50, z: -50..50}

    res =
      input()
      |> Enum.filter(fn {s, c} -> Cube.intersects?(initialization, c) end)

    IO.inspect(res)

    # points = res |> Enum.reduce(MapSet.new(), fn {s, c}, acc ->
    #   m = for x <- c.x, y <- c.y, z <- c.z, reduce: MapSet.new() do m -> MapSet.put(m, {x, y, z}) end
    #   if c == :on, do: MapSet.union(acc, m), else: MapSet.difference(acc, m)
    # end)

    # collect on cubes in list
    # when encountering an off cube, append all intersections with current on cubes to that list

    res = process(res, [])
    IO.inspect(res)

    res = res |> Enum.reduce(0, fn {s, c}, acc ->
      case s do
        :on -> acc + Cube.volume(c)
        :off -> acc - Cube.volume(c)
      end
    end)

    # IO.inspect(MapSet.size(points))

    "not implemented"
    res
  end

  def part2 do
    "not implemented"
  end

  def process([], processed), do: processed |> Enum.reverse()

  def process([{:on, _} = cube | cubes], processed), do: process(cubes, [cube | processed])

  def process([{:off, cube} | cubes], processed) do
    off_cubes =
      for {_, c} <- processed |> Enum.reverse() |> Enum.filter(fn {s, _} -> s == :on end),
          reduce: [] do
        acc ->
          if Cube.intersects?(c, cube), do: [{:off, Cube.intersection(c, cube)} | acc], else: acc
      end

    IO.inspect(off_cubes, label: "generated off cubes")
    IO.inspect(cube, label: "based on ")

    process(cubes, off_cubes ++ processed)
  end

  defp input do
    read_input("22b")
    |> Enum.map(fn l ->
      captures =
        Regex.named_captures(@r, l)
        |> Map.map(fn {k, v} ->
          if k == "s", do: String.to_atom(v), else: String.to_integer(v)
        end)

      {captures["s"], Cube.new(captures)}
    end)
  end
end
