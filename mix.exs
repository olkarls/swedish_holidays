defmodule SwedishHolidays.Mixfile do
  use Mix.Project

  def project do
    [app: :swedish_holidays,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: Coverex.Task],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:tzdata, :logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:timex, "> 0.0.0"},
      {:coverex, "> 0.0.0"},
      {:credo, "> 0.0.0"},
      {:dialyxir, "~> 0.3", only: [:dev, :test]}
    ]
  end
end
