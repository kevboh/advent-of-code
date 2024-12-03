defmodule AdventOfCode.Days.Day3.ParserHelpers do
  import NimbleParsec

  def mult do
    ignore(string("mul("))
    |> integer(max: 3)
    |> ignore(string(","))
    |> integer(max: 3)
    |> ignore(string(")"))
    |> tag(:mult)
  end

  def enable do
    string("do()")
    |> ignore()
    |> tag(:enable)
  end

  def disable do
    string("don't()")
    |> ignore()
    |> tag(:disable)
  end
end

defmodule AdventOfCode.Days.Day3.Parser do
  import NimbleParsec
  import AdventOfCode.Days.Day3.ParserHelpers

  defparsec(
    :program,
    choice([
      enable(),
      disable(),
      mult()
    ])
    |> eventually()
    |> repeat()
  )

  def parse(input) do
    {:ok, out, _, _, _, _} =
      input
      |> program()

    out
  end
end

defmodule AdventOfCode.Days.Day3 do
  import AdventOfCode

  alias AdventOfCode.Days.Day3.Parser

  def part1 do
    input()
    |> Parser.parse()
    |> Enum.map(&instruction/1)
    |> Enum.sum()
  end

  def part2 do
    {_, answer} =
      input()
      |> Parser.parse()
      |> Enum.reduce({:enabled, 0}, fn
        {:mult, [a, b]}, {:enabled, acc} -> {:enabled, acc + a * b}
        {:enable, _}, {_, acc} -> {:enabled, acc}
        {:disable, _}, {_, acc} -> {:disabled, acc}
        _, acc -> acc
      end)

    answer
  end

  defp input do
    read_input(3)
    |> Enum.join()
  end

  defp instruction({:mult, [a, b]}), do: a * b
  defp instruction({:enable, _}), do: 0
  defp instruction({:disable, _}), do: 0
end
