defmodule AdventOfCode.Days.Day2 do
  import AdventOfCode

  @wins %{
    :paper => :rock,
    :rock => :scissors,
    :scissors => :paper
  }
  @loses Map.new(@wins, fn {key, val} -> {val, key} end)

  def part1 do
    input()
    |> Stream.map(&plays_1/1)
    |> Stream.map(&score/1)
    |> Enum.sum()
  end

  def part2 do
    input()
    |> Stream.map(&plays_2/1)
    |> Stream.map(&score/1)
    |> Enum.sum()
  end

  defp input do
    read_input(2)
  end

  defp they_play("A"), do: :rock
  defp they_play("B"), do: :paper
  defp they_play("C"), do: :scissors

  defp i_play("X"), do: :rock
  defp i_play("Y"), do: :paper
  defp i_play("Z"), do: :scissors

  defp want("X"), do: :loss
  defp want("Y"), do: :draw
  defp want("Z"), do: :win

  defp plays_1(<<them::binary-size(1), " ", me::binary-size(1), "\n">>),
    do: {they_play(them), i_play(me)}

  defp plays_2(<<them::binary-size(1), " ", me::binary-size(1), "\n">>) do
    played = they_play(them)

    case {played, want(me)} do
      {p, :loss} -> {p, @wins[p]}
      {p, :draw} -> {p, p}
      {p, :win} -> {p, @loses[p]}
    end
  end

  defp beats(a, b), do: b == @wins[a]

  defp outcome({them, me}) do
    case {beats(them, me), beats(me, them)} do
      {true, _} -> :loss
      {_, true} -> :win
      _ -> :draw
    end
  end

  defp outcome_score(:loss), do: 0
  defp outcome_score(:draw), do: 3
  defp outcome_score(:win), do: 6

  defp shape_score(:rock), do: 1
  defp shape_score(:paper), do: 2
  defp shape_score(:scissors), do: 3

  defp score({them, me}), do: (outcome({them, me}) |> outcome_score()) + shape_score(me)
end
