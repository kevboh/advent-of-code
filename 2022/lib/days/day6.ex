defmodule AdventOfCode.Days.Day6 do
  import AdventOfCode

  def part1 do
    find_start(0..3, input())
  end

  def part2 do
    find_start(0..13, input())
  end

  defp input do
    read_input(6)
    |> Enum.to_list()
    |> hd()
  end

  defp find_start(view, str) do
    # this could be far more terse if we assume there is always a valid starting packet
    # but SOMEONE has been a STICKLER for EDGE CASES
    case String.slice(str, view) do
      "" ->
        :not_found

      v ->
        cond do
          String.length(v) < 4 ->
            :not_found

          unique(v) ->
            _..last = view
            last + 1

          true ->
            find_start(Range.shift(view, 1), str)
        end
    end
  end

  defp unique(str) do
    c = String.codepoints(str)
    length(Enum.uniq(c)) == length(c)
  end
end
