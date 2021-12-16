defmodule AdventOfCode.Days.Day6 do
  import AdventOfCode

  def part1 do
    simulate(get_seed(), 80)
  end

  def part2 do
    seeds = get_seed()

    freqs =
      seeds
      |> Enum.frequencies()

    freqs =
      for _gen <- 1..256, reduce: freqs do
        acc -> next_gen_freqs(acc)
      end

    freqs |> Map.values() |> Enum.sum()
  end

  defp input do
    read_input(6)
  end

  defp get_seed() do
    input()
    |> hd()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp simulate(seed, generations) do
    for _gen <- 1..generations, reduce: seed do
      acc ->
        next_generation(acc)
    end
    |> Enum.to_list()
    |> length()
  end

  defp next_generation(fish) do
    fish
    |> Enum.flat_map(fn x ->
      y = x - 1
      if y < 0, do: [6, 8], else: [y]
    end)
  end

  defp next_gen_freqs(freqs) do
    %{
      0 => freqs[1],
      1 => freqs[2],
      2 => freqs[3],
      3 => freqs[4],
      4 => freqs[5],
      5 => freqs[6],
      6 => safe(freqs[7]) + safe(freqs[0]),
      7 => freqs[8],
      8 => freqs[0]
    }
  end

  defp safe(a), do: if(a == nil, do: 0, else: a)
end
