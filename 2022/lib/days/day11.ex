defmodule AdventOfCode.Days.Day11.Monkey.Parsers do
  import NimbleParsec

  def name do
    ignore(string("Monkey "))
    |> integer(min: 1)
    |> ignore(string(":"))
    |> unwrap_and_tag(:name)
  end

  def items do
    ignore(string("Starting items: "))
    |> repeat(integer(min: 1) |> ignore(optional(string(", "))))
    |> tag(:items)
  end

  def operation do
    ignore(string("Operation: new = old "))
    |> choice([string("+"), string("*")])
    |> ignore(string(" "))
    |> choice([integer(min: 1), string("old")])
    |> tag(:operation)
  end

  def test do
    ignore(string("Test: divisible by "))
    |> integer(min: 1)
    |> unwrap_and_tag(:test)
  end

  def throw_to(condition) do
    ignore(string("If "))
    |> ignore(string(condition))
    |> ignore(string(": throw to monkey "))
    |> integer(min: 1)
    |> unwrap_and_tag(String.to_atom("if_" <> condition))
  end

  def monkey do
    [name(), items(), operation(), test(), throw_to("true"), throw_to("false")]
    |> Enum.reduce(fn c, acc ->
      acc |> ignore(string("\n")) |> concat(c)
    end)
    |> ignore(string("\n"))
    |> wrap()
  end
end

defmodule AdventOfCode.Days.Day11.Monkey do
  import NimbleParsec
  alias AdventOfCode.Days.Day11.Monkey.Parsers

  defparsec(:parse, repeat(Parsers.monkey()))

  def from(s, divisor) do
    parse(s)
    |> elem(1)
    |> Enum.map(&Map.new/1)
    |> Enum.reduce(%{}, fn m, acc ->
      Map.put(acc, m[:name], Map.merge(m, %{inspections: 0, divisor: divisor}))
    end)
  end

  def do_round(_round, monkeys) do
    monkeys
    |> Map.keys()
    |> Enum.sort(:asc)
    |> Enum.reduce(monkeys, &take_turns/2)
  end

  def take_turns(name, monkeys) do
    shared_test = monkeys |> Map.values() |> Enum.map(& &1.test) |> Enum.product()
    m = monkeys[name]

    case m[:items] do
      [] ->
        monkeys

      [item | rest] ->
        item = Integer.mod(inspect_item(item, m[:operation]), shared_test)
        item = trunc(item / m[:divisor])
        target = test(item, m)

        monkeys =
          update_in(monkeys[target].items, fn items ->
            items ++ [item]
          end)

        monkeys =
          update_in(monkeys[name], fn um ->
            %{um | items: rest, inspections: um.inspections + 1}
          end)

        take_turns(name, monkeys)
    end
  end

  defp inspect_item(item, [op, v]) when op == "+" and v == "old", do: item + item
  defp inspect_item(item, [op, v]) when op == "+", do: item + v
  defp inspect_item(item, [op, v]) when op == "*" and v == "old", do: item * item
  defp inspect_item(item, [op, v]) when op == "*", do: item * v

  defp test(item, m) do
    if Integer.mod(item, m[:test]) == 0, do: m[:if_true], else: m[:if_false]
  end
end

defmodule AdventOfCode.Days.Day11 do
  import AdventOfCode
  alias AdventOfCode.Days.Day11.Monkey

  def part1 do
    Enum.reduce(1..20, Monkey.from(input(), 3), &Monkey.do_round/2)
    |> Map.values()
    |> Enum.map(& &1.inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def part2 do
    Enum.reduce(1..10000, Monkey.from(input(), 1), &Monkey.do_round/2)
    |> Map.values()
    |> Enum.map(& &1.inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  defp input do
    read_input(11)
    |> Stream.map(&String.trim_leading/1)
    |> Enum.join("")
  end
end
