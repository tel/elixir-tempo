defmodule Tempo.MixProject do
  use Mix.Project

  def project do
    [
      app: :tempo,
      elixir: "~> 1.7",
      version: "0.1.0",
      deps: deps(),
      # Docs
      name: "Tempo",
      source_url: "https://github.com/tel/elixir-tempo",
      homepage_url: "https://github.com/tel/elixir-tempo",
      docs: [
        main: "Tempo",
        extras: ["README.md"]
      ],
      # Startup
      start_permanent: Mix.env() == :prod
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:html_entities, "~> 0.4"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end
end
