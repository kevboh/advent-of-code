defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.14"},
      {:flow, "~> 1.2.0"},
      {:nimble_parsec, "~> 1.4"}
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      start: &start/1,
      solve: ["advent.solve"]
    ]
  end

  defp start(day) do
    Mix.Task.run("advent.fetch_input", day)
    Mix.Task.run("advent.gen.day", day)
  end
end
