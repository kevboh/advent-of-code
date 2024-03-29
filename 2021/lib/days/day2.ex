defmodule AdventOfCode.Days.Day2 do
  import AdventOfCode

  def part1 do
    AdventOfCode.Days.Day2.Part1.run()
  end

  def part2 do
    AdventOfCode.Days.Day2.Part2.run()
  end

  def input do
    read_input(2)
  end
end

defmodule AdventOfCode.Days.Day2.Part1 do
  alias AdventOfCode.Days.Day2

  def run do
    acc =
      Day2.input()
      |> Enum.reduce(%{"horizontal" => 0, "depth" => 0}, &accumulate_position/2)

    Integer.to_string(acc["horizontal"] * acc["depth"])
  end

  defp accumulate_position("forward " <> units, acc) do
    Map.update!(acc, "horizontal", &(&1 + String.to_integer(units)))
  end

  defp accumulate_position("down " <> units, acc) do
    Map.update!(acc, "depth", &(&1 + String.to_integer(units)))
  end

  defp accumulate_position("up " <> units, acc) do
    Map.update!(acc, "depth", &(&1 - String.to_integer(units)))
  end
end

defmodule AdventOfCode.Days.Day2.Part2 do
  alias AdventOfCode.Days.Day2

  def run do
    acc =
      Day2.input()
      |> Enum.reduce(%{"horizontal" => 0, "depth" => 0, "aim" => 0}, &accumulate_position/2)

    Integer.to_string(acc["horizontal"] * acc["depth"])
  end

  defp accumulate_position("forward " <> units, acc) do
    units_i = String.to_integer(units)

    acc
    |> Map.update!("horizontal", &(&1 + units_i))
    |> Map.update!("depth", &(&1 + acc["aim"] * units_i))
  end

  defp accumulate_position("down " <> units, acc) do
    Map.update!(acc, "aim", &(&1 + String.to_integer(units)))
  end

  defp accumulate_position("up " <> units, acc) do
    Map.update!(acc, "aim", &(&1 - String.to_integer(units)))
  end
end
