defmodule AdventOfCode.Days.Day5 do
  import AdventOfCode

  def part1 do
    moves()
    |> Enum.reduce(stacks(), &move_p1/2)
    |> Enum.map(&List.first/1)
    |> Enum.join("")
  end

  def part2 do
    moves()
    |> Enum.reduce(stacks(), &move_p2/2)
    |> Enum.map(&List.first/1)
    |> Enum.join("")
  end

  defp input do
    read_input(5)
  end

  defp stacks() do
    input()
    |> Stream.take_while(&is_stack?/1)
    # Convert stack ASCII into a list of characters and transpose it.
    |> Stream.map(&String.codepoints/1)
    |> Enum.to_list()
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    # Take every 4th list starting at 1, aka every now-ordered stack.
    # The head of each stack is its topmost crate.
    |> Enum.drop(1)
    |> Enum.take_every(4)
    |> Enum.map(&Enum.reject(&1, fn e -> e == " " end))
  end

  defp moves() do
    input()
    |> Stream.filter(&String.starts_with?(&1, "move"))
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_move/1)
  end

  defp is_stack?(line), do: String.starts_with?(line, "[") or String.starts_with?(line, "  ")

  @move_regex ~r/move (?<n>\d+) from (?<source>\d+) to (?<dest>\d+)/
  defp parse_move(m) do
    %{
      "n" => n,
      "source" => source,
      "dest" => dest
    } = Regex.named_captures(@move_regex, m)

    {String.to_integer(n), String.to_integer(source) - 1, String.to_integer(dest) - 1}
  end

  defp move_p1({0, _source, _dest}, stacks), do: stacks

  defp move_p1({n, source, dest}, stacks) do
    # Is there a cleaner way to do this?
    # I literally just want to fiddle with two elements...
    r =
      case Enum.at(stacks, source) do
        [] ->
          stacks

        [h | rest] ->
          stacks
          |> Enum.with_index()
          |> Enum.reduce([], fn {stack, i}, acc ->
            s =
              case i do
                ^source -> rest
                ^dest -> [h | stack]
                _ -> stack
              end

            [s | acc]
          end)
          |> Enum.reverse()
      end

    move_p1({n - 1, source, dest}, r)
  end

  defp move_p2({n, source, dest}, stacks) do
    {h, rest} = Enum.at(stacks, source) |> Enum.split(n)

    stacks
    |> Enum.with_index()
    |> Enum.reduce([], fn {stack, i}, acc ->
      s =
        case i do
          ^source -> rest
          ^dest -> List.flatten([h | stack])
          _ -> stack
        end

      [s | acc]
    end)
    |> Enum.reverse()
  end
end
