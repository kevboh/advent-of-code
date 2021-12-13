defmodule AdventOfCode.Days.Day13 do
  import AdventOfCode

  def part1 do
    {dots, folds} = parse()
    fold(dots, hd(folds)) |> MapSet.size()
  end

  def part2 do
    {dots, folds} = parse()

    dots =
      for fold <- folds, reduce: dots do
        dots ->
          fold(dots, fold)
      end

    ["\n" | render(dots) |> Enum.reverse()]
    |> Enum.join("\n")
  end

  defp input do
    read_input(13)
  end

  defp parse do
    {dots, folds} =
      input()
      |> Enum.reduce({[], []}, fn e, {dots, folds} ->
        case Regex.run(~r/(\d+),(\d+)/i, e, capture: :all_but_first) do
          [x, y] ->
            {[{String.to_integer(x), String.to_integer(y)} | dots], folds}

          nil ->
            case Regex.run(~r/fold along ([xy])=(\d+)/i, e, capture: :all_but_first) do
              [direction, line] ->
                {dots, [{String.to_atom(direction), String.to_integer(line)} | folds]}

              nil ->
                {dots, folds}
            end
        end
      end)

    {MapSet.new(dots), folds |> Enum.reverse()}
  end

  defp fold(dots, {direction, line}) do
    dots
    |> MapSet.to_list()
    |> Enum.map(fn {x, y} ->
      case direction do
        :x when x > line ->
          diff = (x - line) * 2
          {x - diff, y}

        :y when y > line ->
          diff = (y - line) * 2
          {x, y - diff}

        _ ->
          {x, y}
      end
    end)
    |> MapSet.new()
  end

  defp render(dot_list, x \\ 0) do
    if dot_list |> Enum.map(fn {x1, y1} -> x1 end) |> Enum.all?(fn x1 -> x1 < x end) do
      []
    else
      this_line =
        dot_list
        |> Enum.filter(fn {x1, y1} -> x == x1 end)

      y_values =
        this_line
        |> Enum.map(fn {x1, y1} -> y1 end)
        |> MapSet.new()

      line =
        for y <- 0..(y_values |> MapSet.to_list() |> Enum.max(&>=/2, fn -> 0 end)),
            into: "",
            do: if(MapSet.member?(y_values, y), do: "#", else: ".")

      [line | render(dot_list, x + 1)]
    end
  end
end
