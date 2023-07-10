defmodule IascHordeExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :iasc_elixir_horde_minimal_example,
      version: "0.1.0",
      elixir: "~> 1.13-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {IascHordeExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:horde, "~> 0.8.3"}
    ]
  end
end
