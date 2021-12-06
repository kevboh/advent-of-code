defmodule AdventOfCode.Days.Day6 do
  import AdventOfCode

  def part1 do
    simulate(get_seed(), 80)
  end

  # I didn't submit this part because I gave up and cribbed it from https://github.com/zperrault/advent-of-code/blob/main/2021/lib/2021/6.ex
  def part2 do
    seeds = get_seed()

    freqs =
      seeds
      |> Enum.frequencies()

    freq_counts =
      for i <- 0..8,
          do:
            Map.get(
              freqs,
              i,
              0
            )

    rotate_gen(255, freq_counts) |> Enum.sum()
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

  defp rotate_gen(gen, [f0, f1, f2, f3, f4, f5, f6, f7, f8]) do
    res = [f1, f2, f3, f4, f5, f6, f7 + f0, f8, f0]
    if gen <= 0, do: res, else: rotate_gen(gen - 1, res)
  end
end
