defmodule AdventOfCode.Days.Day19.Scanner do
  defstruct [:name, :position, beacons: []]
end

defmodule AdventOfCode.Days.Day19 do
  import AdventOfCode

  alias AdventOfCode.Days.Day19.Scanner

  @scanner_name ~r/--- scanner (?<name>\d+) ---/

  def part1 do
    [ref | scanners] = input()

    solve_p1(ref, scanners)
  end

  def part2 do
    [ref | scanners] = input()

    ref = %{ref | position: {0, 0, 0}}

    located_scanners = locate_scanners(ref, scanners, [ref])

    for s1 <- located_scanners, s2 <- located_scanners, reduce: 0 do
      acc ->
        max(acc, m(s1.position, s2.position))
    end
  end

  defp m({x1, y1, z1}, {x2, y2, z2}), do: abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)

  defp solve_p1(ref, []), do: ref.beacons |> length()

  defp solve_p1(ref, remaining) do
    # grab the first rotated/translated scanner that matches our reference
    {match, remaining} = extract_first_overlap(ref, remaining)

    # merge that scanner with our reference
    ref = %{ref | beacons: Enum.concat(ref.beacons, match.beacons) |> Enum.uniq()}
    solve_p1(ref, remaining)
  end

  defp locate_scanners(_, [], found), do: found

  defp locate_scanners(ref, remaining, found) do
    {match, remaining} = extract_first_overlap(ref, remaining)
    ref = %{ref | beacons: Enum.concat(ref.beacons, match.beacons) |> Enum.uniq()}
    locate_scanners(ref, remaining, [match | found])
  end

  defp extract_first_overlap(ref, scanners) do
    {scanner, {_, translated_beacons, translation}} =
      scanners
      |> Enum.reduce_while(nil, fn s, acc ->
        case compare(ref, s) do
          nil -> {:cont, acc}
          solution -> {:halt, {s, solution}}
        end
      end)

    scanner = %{scanner | beacons: translated_beacons, position: translation}
    {scanner, Enum.reject(scanners, fn s -> s.name == scanner.name end)}
  end

  defp compare(ref, sc) do
    rotations = rotations(sc)

    # for each rotation of sc, see if any can translate into ref
    rotations
    |> Map.to_list()
    |> Enum.reduce_while(nil, fn {rotation, beacons}, acc ->
      [{{tx, ty, tz}, freq} | _] =
        for(
          {bx, by, bz} <- beacons,
          {rx, ry, rz} <- ref.beacons,
          into: [],
          do: {bx - rx, by - ry, bz - rz}
        )
        |> Enum.frequencies()
        |> Map.to_list()
        |> Enum.sort(fn {_, f1}, {_, f2} -> f1 > f2 end)

      if freq >= 12 do
        translated = beacons |> Enum.map(fn {x, y, z} -> {x - tx, y - ty, z - tz} end)

        {:halt, {rotation, translated, {tx, ty, tz}}}
      else
        {:cont, acc}
      end
    end)
  end

  defp rotations(scanner) do
    scanner.beacons
    |> Enum.reduce(%{}, fn {x, y, z}, m ->
      # 90 degree rotations around x+ (:xp)
      m = ap(m, :xp0, {+x, +y, +z})
      m = ap(m, :xp90, {+x, -z, +y})
      m = ap(m, :xp180, {+x, -y, -z})
      m = ap(m, :xp270, {+x, +z, -y})
      # 90 degree rotations around x- (:xn)
      m = ap(m, :xn0, {-x, -y, +z})
      m = ap(m, :xn90, {-x, +z, +y})
      m = ap(m, :xn180, {-x, +y, -z})
      m = ap(m, :xn270, {-x, -z, -y})
      # 90 degree rotations around y+ (:yp)
      m = ap(m, :yp0, {+y, +z, +x})
      m = ap(m, :yp90, {+y, -x, +z})
      m = ap(m, :yp180, {+y, -z, -x})
      m = ap(m, :yp270, {+y, +x, -z})
      # negative y
      m = ap(m, :yn0, {-y, -z, +x})
      m = ap(m, :yn90, {-y, +x, +z})
      m = ap(m, :yn180, {-y, +z, -x})
      m = ap(m, :yn270, {-y, -x, -z})
      # positive z
      m = ap(m, :zp0, {+z, +x, +y})
      m = ap(m, :zp90, {+z, -y, +x})
      m = ap(m, :zp180, {+z, -x, -y})
      m = ap(m, :zp270, {+z, +y, -x})
      # negative z
      m = ap(m, :zn0, {-z, -x, +y})
      m = ap(m, :zn90, {-z, +y, +x})
      m = ap(m, :zn180, {-z, +x, -y})
      ap(m, :zn270, {-z, -y, -x})
    end)
  end

  defp ap(map, k, a) do
    Map.update(map, k, [a], fn b -> [a | b] end)
  end

  defp input do
    [first | rest] = read_input(19)

    rest
    |> Enum.reduce([%Scanner{name: scanner_name(first)}], fn line, acc ->
      case scanner_name(line) do
        nil ->
          [x, y, z] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
          b = {x, y, z}

          [current | rest] = acc
          current = ap(current, :beacons, b)
          [current | rest]

        name ->
          [%Scanner{name: name} | acc]
      end
    end)
    |> Enum.reverse()
  end

  defp scanner_name(line),
    do:
      Regex.named_captures(@scanner_name, line)
      |> then(fn m -> if m == nil, do: nil, else: Map.get(m, "name") end)
end
