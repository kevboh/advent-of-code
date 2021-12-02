# AdventOfCode 2021

My 2021 Advent of Code solutions. I chose Elixir this year, both because I want
to get better at Elixir and also because I need a language that can deal with
string/stream parsing easily—that was my downfall last year with Swift, a
language ill-suited to quickly throwing together string-parsing solutions.

While I have considered tools to make my solutions more concise or automated,
like [this one](https://github.com/mathsaey/advent_of_code_utils), I'm sticking
with setting each day up manually for now until I have a feel for how best to
automate my own process. In other words, I'm avoiding my own premature
optimization and forcing myself to learn the bundled tools.

## Solving Puzzles

For a given day:

1. `mix advent.fetch_input [year].[day_num]`
2. Create module `AdventOfCode.Days.Day[day_num]` in `lib/days/day[day_num].ex`
   and implement `part1` and `part2` functions. I should templatize this via a
   generator.
3. Implement those functions, returning the answer as a string.
4. Run `mix advent.solve [day_num]` to print the answer for both parts.
