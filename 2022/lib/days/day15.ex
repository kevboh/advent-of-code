defmodule AdventOfCode.Days.Day15 do
  import AdventOfCode

  def part1 do
    pairs = input()

    dim = fn a, b ->
      pairs
      |> Enum.map(fn {s = {sx, _}, b} ->
        a.(sx, md(s, b))
      end)
      |> b.()
    end

    min = dim.(&-/2, &Enum.min/1)
    max = dim.(&+/2, &Enum.max/1)

    for x <- min..max, reduce: 0 do
      acc -> acc + within(pairs, {x, 2_000_000}, true)
    end
  end

  def part2 do
    pairs = input()

    space = 0..4_000_000

    # check every point just outside the border of every sensor's radius
    # thanks, reddit
    {x, y} =
      pairs
      |> Enum.reduce_while(nil, fn {s = {sx, sy}, b}, _ ->
        d = md(s, b) + 1

        [
          #   /\ <
          #   \/
          search_side(sx..(sx + d), (sy - d)..sy, pairs, space),
          #   /\
          #   \/ <
          search_side((sx + d)..sx, sy..(sy + d), pairs, space),
          #   /\
          # > \/
          search_side(sx..(sx - d), (sy + d)..sy, pairs, space),
          # > /\
          #   \/
          search_side((sx - d)..sx, sy..(sy - d), pairs, space)
        ]
        |> Enum.find(fn e -> not is_nil(e) end)
        |> then(&if not is_nil(&1), do: {:halt, &1}, else: {:cont, nil})
      end)

    x * 4_000_000 + y
  end

  def input do
    read_input(15)
    |> Stream.map(&coords/1)
    |> Enum.to_list()
  end

  def coords(line) do
    line
    |> String.split(":")
    |> Enum.map(&coord/1)
    |> List.to_tuple()
  end

  def coord(part) do
    r = ~r/x=(?<xn>-?)(?<x>\d+), y=(?<yn>-?)(?<y>\d+)/
    c = Regex.named_captures(r, part)

    v = fn k ->
      i = String.to_integer(c[k])

      case c[k <> "n"] do
        "-" -> -i
        _ -> i
      end
    end

    {v.("x"), v.("y")}
  end

  def within([], _, _), do: 0

  def within([{signal, beacon} | rest], p, include_beacons) do
    if (not include_beacons or beacon != p) and md(signal, beacon) >= md(signal, p) do
      1
    else
      within(rest, p, include_beacons)
    end
  end

  def md({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def search_side(x_range, y_range, pairs, space) do
    Enum.zip(x_range, y_range)
    |> Enum.filter(fn {x, y} -> x in space and y in space end)
    |> search(pairs)
  end

  def search([], _), do: nil

  def search([candidate | rest], pairs) do
    if within(pairs, candidate, false) == 1, do: search(rest, pairs), else: candidate
  end
end
