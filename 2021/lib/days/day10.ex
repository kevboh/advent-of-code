defmodule AdventOfCode.Days.Day10 do
  import AdventOfCode
  alias AdventOfCode.Days.Day10.Chunk

  @closing_sigils %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  @p1_scores %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  @p2_scores %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }

  def part1 do
    input()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&parse/1)
    |> Enum.reject(&is_list/1)
    |> Enum.map(&@p1_scores[&1])
    |> Enum.sum()
  end

  def part2 do
    score_p2 = fn seq ->
      Enum.reduce(seq, 0, fn sigil, acc ->
        acc * 5 + @p2_scores[sigil]
      end)
    end

    res =
      input()
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&parse/1)
      |> Enum.filter(&is_list/1)
      |> Enum.map(fn seq -> Enum.map(seq, &@closing_sigils[&1]) end)
      |> Enum.map(score_p2)
      |> Enum.sort()

    middle_index = trunc(length(res) / 2)

    Enum.at(res, middle_index)
  end

  defp input do
    read_input(10)
  end

  defp parse(a, stack \\ [])

  defp parse([], stack), do: stack

  defp parse([s | rest], stack) when s in ["(", "{", "[", "<"] do
    parse(rest, [s | stack])
  end

  defp parse([s | rest], stack) when s in [")", "}", "]", ">"] do
    [t | stack] = stack
    if s != @closing_sigils[t], do: s, else: parse(rest, stack)
  end

  # Leaving this in as a testament to my tendency to overcomplicate things

  defp parse_whyd_you_have_to_go_and_make_things_so_complicated(i),
    do: parse_whyd_you_have_to_go_and_make_things_so_complicated(i, [])

  defp parse_whyd_you_have_to_go_and_make_things_so_complicated([s | rest], ancestors)
       when s in ["(", "{", "[", "<"] do
    child = Chunk.new(s)
    IO.puts("entering #{s}")
    IO.inspect([child | ancestors])
    parse_whyd_you_have_to_go_and_make_things_so_complicated(rest, [child | ancestors])
  end

  defp parse_whyd_you_have_to_go_and_make_things_so_complicated([s | rest], ancestors)
       when s in [")", "}", "]", ">"] do
    IO.puts("entering #{s}")
    IO.inspect(ancestors)

    [child | parents] = ancestors
    target = Chunk.closing_sigil(child)

    child =
      case s do
        ^target ->
          Map.put(child, :status, :closed)

        _ ->
          child
      end

    parents =
      if length(parents) > 0 do
        [parent | grandparents] = parents
        parent = Map.update(parent, :children, [child], fn c -> c ++ [child] end)
        [parent | grandparents]
      else
        [child]
      end

    IO.inspect(parents)

    parse_whyd_you_have_to_go_and_make_things_so_complicated(rest, parents)
  end

  defp parse_whyd_you_have_to_go_and_make_things_so_complicated([], ancestors), do: ancestors
end

defmodule AdventOfCode.Days.Day10.Chunk do
  defstruct [:sigil, status: :open, children: []]

  def new(sigil) do
    %AdventOfCode.Days.Day10.Chunk{sigil: sigil}
  end

  def closing_sigil(chunk) do
    case chunk.sigil do
      "(" -> ")"
      "[" -> "]"
      "{" -> "}"
      "<" -> ">"
      _ -> :none
    end
  end
end
