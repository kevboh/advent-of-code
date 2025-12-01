defmodule Mix.Tasks.Advent.FetchInput do
  @moduledoc "Task to fetch a day’s input: mix advent.fetch_input 1"

  use Mix.Task
  import Mix.Generator

  @shortdoc "Fetches an Advent of Code input by day."
  @impl Mix.Task
  def run([day]) do
    # Load config for :advent_of_code
    Mix.Task.run("app.config")
    {:ok, _} = Application.ensure_all_started(:req)

    session = Application.get_env(:advent_of_code, :session)
    year = Application.get_env(:advent_of_code, :year)

    input_path = "priv/inputs/#{String.to_integer(day)}.txt"

    %{body: result} =
      Req.get!("https://adventofcode.com/#{year}/day/#{day}/input",
        headers: [{"Cookie", "session=#{session}"}]
      )

    create_file(input_path, result, force: true)
  end
end
