defmodule AdventOfCode.Days.Day17 do
  import AdventOfCode

  def part1 do
    target = input()

    res =
      for vx <- 1..100, vy <- 1..1000, into: [] do
        case falls_in_target(target, {vx, vy}) do
          {:ok, _, highest} ->
            highest

          {:error, _, highest} ->
            0
        end
      end

    res |> Enum.max()
  end

  def part2 do
    target = input()

    res =
      for vx <- 1..314, vy <- -80..10000, reduce: [] do
        acc ->
          case falls_in_target(target, {vx, vy}) do
            {:ok, _, _} ->
              [{vx, vy} | acc]

            {:error, _, highest} ->
              acc
          end
      end

    res |> Enum.uniq() |> length()
  end

  defp falls_in_target(target, velocity, current \\ {0, 0}, step \\ 1, highest \\ 0)

  defp falls_in_target({x_target, y_target}, {x_velocity, y_velocity}, {x, y}, step, highest) do
    highest = max(highest, y)

    cond do
      x in x_target && y in y_target ->
        {:ok, step, highest}

      x > x_target.last || y < y_target.first || (x_velocity == 0 && x not in x_target) ->
        {:error, step, highest}

      true ->
        x = x + x_velocity

        x_velocity =
          x_velocity - if x_velocity == 0, do: 0, else: if(x_velocity > 0, do: 1, else: -1)

        y = y + y_velocity
        y_velocity = y_velocity - 1

        falls_in_target(
          {x_target, y_target},
          {x_velocity, y_velocity},
          {x, y},
          step + 1,
          highest
        )
    end
  end

  defp input do
    captures =
      Regex.named_captures(
        ~r/target area: x=(?<minx>-?\d+)\.\.(?<maxx>-?\d+), y=(?<miny>-?\d+)\.\.(?<maxy>-?\d+)/i,
        read_input(17) |> hd()
      )
      |> Map.map(fn {_, v} -> String.to_integer(v) end)

    {captures["minx"]..captures["maxx"], captures["miny"]..captures["maxy"]}
  end
end
