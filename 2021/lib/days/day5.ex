defmodule AdventOfCode.Days.Day5 do
  import AdventOfCode

  def part1 do
    chart =
      input()
      |> Enum.reduce(%{}, fn line, acc ->
        [{x1, y1}, {x2, y2}] = line_to_points(line)

        case {x1 == x2, y1 == y2} do
          # ignore diagonals
          {false, false} ->
            acc

          {true, false} ->
            # fill vertical
            for y <- Enum.to_list(y1..y2), reduce: acc do
              accy ->
                inc(accy, {x1, y})
            end

          {false, true} ->
            # fill horizontal
            for x <- Enum.to_list(x1..x2), reduce: acc do
              accx ->
                inc(accx, {x, y1})
            end

          {true, true} ->
            # fill point
            inc(acc, {x1, y1})
        end
      end)

    chart |> Map.values() |> Enum.filter(fn t -> t >= 2 end) |> length()
  end

  def part2 do
    chart =
      input()
      |> Enum.reduce(%{}, fn line, acc ->
        [{x1, y1}, {x2, y2}] = line_to_points(line)

        case {x1 == x2, y1 == y2} do
          {false, false} ->
            # fill diagonal
            for p <- Enum.zip(Enum.to_list(x1..x2), Enum.to_list(y1..y2)), reduce: acc do
              accd -> inc(accd, p)
            end

          {true, false} ->
            # fill vertical
            for y <- Enum.to_list(y1..y2), reduce: acc do
              accy ->
                inc(accy, {x1, y})
            end

          {false, true} ->
            # fill horizontal
            for x <- Enum.to_list(x1..x2), reduce: acc do
              accx ->
                inc(accx, {x, y1})
            end

          {true, true} ->
            # fill point
            inc(acc, {x1, y1})
        end
      end)

    chart |> Map.values() |> Enum.filter(fn t -> t >= 2 end) |> length()
  end

  defp input do
    read_input(5)
  end

  defp line_to_points(line) do
    String.split(line, " -> ", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp inc(map, key) do
    Map.update(map, key, 1, &(&1 + 1))
  end
end
