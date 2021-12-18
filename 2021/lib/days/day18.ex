defmodule AdventOfCode.Days.Day18 do
  import AdventOfCode

  @pair ~r/^(?<left>\d+),(?<right>\d+)(?<rest>].*)/

  def part1 do
    [first | rest] = input()

    res =
      rest
      |> Enum.reduce(first, fn e, acc ->
        add(acc, e)
      end)

    magnitude(res)
  end

  def part2 do
    numbers = input()

    for l <- numbers, r <- Enum.reject(numbers, fn n -> n == l end), reduce: 0 do
      acc ->
        sum = add(l, r)
        m = magnitude(sum)
        if m > acc, do: m, else: acc
    end
  end

  def add(a, b) do
    sum = "[#{a},#{b}]"
    do_reduce(sum)
  end

  defp do_reduce(unreduced_sum) do
    case reduce(unreduced_sum, false) do
      {:exploded, new_sum} ->
        do_reduce(new_sum)

      {:na, sum} ->
        case reduce(sum, true) do
          {:na, final_sum} ->
            final_sum

          {_, intermediate} ->
            do_reduce(intermediate)
        end
    end
  end

  def reduce(rest, do_splits \\ false, processed \\ "", depth \\ 0)

  def reduce("", _, processed, _), do: {:na, processed}

  def reduce("," <> rest, do_splits, processed, depth),
    do: reduce(rest, do_splits, processed <> ",", depth)

  def reduce("[" <> rest, do_splits, processed, depth) do
    if depth >= 4 && has_pair(rest) do
      # explode
      {left, right, rest} = match_pair(rest)
      processed = explode_left(processed, left)
      rest = explode_right(rest, right)

      {:exploded, processed <> "0" <> rest}
    else
      reduce(rest, do_splits, processed <> "[", depth + 1)
    end
  end

  def reduce("]" <> rest, do_splits, processed, depth),
    do: reduce(rest, do_splits, processed <> "]", depth - 1)

  def reduce(rest, do_splits, processed, depth) do
    case match_pair(rest) do
      {left, right, rest} ->
        {cat, did_split} =
          cond do
            do_splits && left > 9 ->
              s = split(left)
              {"#{s},#{right}", true}

            do_splits && right > 9 ->
              s = split(right)
              {"#{left},#{s}", true}

            true ->
              {"#{left},#{right}", false}
          end

        if did_split do
          {:split, processed <> cat <> rest}
        else
          reduce(rest, do_splits, processed <> cat, depth)
        end

      false ->
        {value, rest} = match_value(rest)

        {cat, did_split} =
          if do_splits && value > 9 do
            {split(value), true}
          else
            {"#{value}", false}
          end

        if did_split do
          {:split, processed <> cat <> rest}
        else
          reduce(rest, do_splits, processed <> cat, depth)
        end
    end
  end

  defp has_pair(a), do: Regex.match?(@pair, a)

  defp match_pair(a) do
    case Regex.named_captures(@pair, a) do
      %{"left" => left, "right" => right, "rest" => rest} ->
        {String.to_integer(left), String.to_integer(right), rest}

      _ ->
        false
    end
  end

  defp match_value(a) do
    case Regex.named_captures(~r/^(?<left>\d+)(?<rest>,\[.*)/, a) do
      %{"left" => left, "rest" => rest} ->
        {String.to_integer(left), rest}

      _ ->
        case Regex.named_captures(~r/^(?<right>\d+)(?<rest>\].*)/, a) do
          %{"right" => right, "rest" => rest} -> {String.to_integer(right), rest}
          _ -> false
        end
    end
  end

  defp explode_left(str, add) do
    case Regex.named_captures(~r/^(?<prev>.*[],[])(?<last>\d+)(?<rem>[,\][]*)/, str) do
      %{"last" => last, "prev" => prev, "rem" => rem} ->
        new = String.to_integer(last) + add
        res = prev <> Integer.to_string(new) <> rem

        if !String.ends_with?(res, "[") && !String.ends_with?(res, ",") do
          res <> ","
        else
          res
        end

      _ ->
        str
    end
  end

  defp explode_right(str, add) do
    res =
      String.replace(str, ~r/\d+/, fn m -> Integer.to_string(String.to_integer(m) + add) end,
        global: false
      )

    if String.starts_with?(res, "]") do
      String.slice(res, 1..-1)
    else
      res
    end
  end

  defp split(a) do
    left = trunc(a / 2)
    right = round(a / 2)
    "[#{left},#{right}]"
  end

  defp magnitude(a) do
    if Regex.match?(~r/\[\d+,\d+\]/, a) do
      String.replace(a, ~r/\[\d+,\d+\]/, fn m ->
        %{"x" => x, "y" => y} = Regex.named_captures(~r/\[(?<x>\d+),(?<y>\d+)\]/, m)
        Integer.to_string(String.to_integer(x) * 3 + String.to_integer(y) * 2)
      end)
      |> magnitude()
    else
      a |> String.to_integer()
    end
  end

  defp input do
    read_input(18)
  end
end
