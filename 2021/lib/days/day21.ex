defmodule AdventOfCode.Days.Day21.DeterministicDice do
  defstruct [state: 1, roll_count: 0]
end

defmodule AdventOfCode.Days.Day21 do
  import AdventOfCode

  alias AdventOfCode.Days.Day21.DeterministicDice

  @p2_winning_score 21

  def part1 do
    d = %DeterministicDice{}

    [p1, p2] = input()

    {p1, d} = move(p1, d)
    IO.inspect({p1, d})

    "not implemented"
    p1_solve(input(), %DeterministicDice{})
  end

  def part2 do
    [p1, p2] = input()

    {p1_wins, p2_wins} = p2_solve_p1({p1, p2}) |> Enum.reduce({0, 0}, fn {p1, p2}, {p1acc, p2acc} ->
      {p1acc + p1, p2acc + p2}
    end)
    IO.inspect({p1_wins, p2_wins})
    max(p1_wins, p2_wins)
  end

  def p1_solve(players, dice) do
    [p1, p2] = players

    {{_, score} = p1, dice} = move(p1, dice)
    if score >= 1000 do
      {_, p2_score} = p2
      p2_score * dice.roll_count
    else
      {{_, score} = p2, dice} = move(p2, dice)
      if score >= 1000 do
        {_, p1_score} = p1
        p1_score * dice.roll_count
      else
        p1_solve([p1, p2], dice)
      end
    end
  end

  def p2_solve_p1({{p1_pos, p1_score}, {p2_pos, p2_score}}) do
    p1s = for d1 <- 1..3, d2 <- 1..3, d3 <- 1..3, into: [] do
      pos = rotate(p1_pos, d1 + d2 + d3)
      {pos, p1_score + pos}
    end

    p1_remaining = p1s |> Enum.filter(fn {_, score} -> score < @p2_winning_score end)
    p1_win_count = length(p1s) - length(p1_remaining)

    p2s = p1_remaining |> Enum.flat_map(fn p1 ->
      for d1 <- 1..3, d2 <- 1..3, d3 <- 1..3, into: [] do
        pos = rotate(p2_pos, d1 + d2 + d3)
        {p1, {pos, p2_score + pos}}
      end
    end)

    p2_remaining = p2s |> Enum.filter(fn {_, {_, score}} -> score < @p2_winning_score end)
    p2_win_count = length(p2s) - length(p2_remaining)

    [{p1_win_count, p2_win_count} | p2_remaining |> Enum.flat_map(&p2_solve_p1/1)]
  end

  def move({pos, score}, dice) do
    IO.inspect(pos, label: "old_position")
    {res, dice} = roll(dice)
    IO.inspect(res, label: "rolled")
    new_pos = rotate(pos, res)
    IO.inspect(new_pos, label: "new position")
    {{new_pos, score + new_pos}, dice}
  end

  def rotate(pos, by) do
    res = rem(pos + by, 10)
    if res == 0, do: 10, else: res
  end

  defp roll(%DeterministicDice{} = dice) do
    {r1, dice} = roll_(dice)
    {r2, dice} = roll_(dice)
    {r3, dice} = roll_(dice)
    {r1 + r2 + r3, dice}
  end

  defp roll_(%DeterministicDice{state: state} = dice) do
    res = state
    state = if state == 100, do: 1, else: state + 1
    {res, %{dice | state: state, roll_count: dice.roll_count + 1}}
  end

  defp input do
    read_input(21) |> Enum.map(&(&1 |> String.split(":"))) |> Enum.map(fn [_, n] -> {n |> String.trim() |> String.to_integer(), 0} end)
  end
end
