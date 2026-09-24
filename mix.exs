defmodule Smonify.MixProject do
  use Mix.Project

  def project do
    [
      app: :smonify,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Smonify.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # meta
      {:igniter, "~> 0.5", only: :dev},
      {:magritte, "~> 0.1.2"},

      # security & quality
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.15.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},

      # mocking etc...
      {:mox, "~> 1.3", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.8.2", only: [:dev, :test], runtime: false},
      {:faker, "~> 0.19.0", only: [:dev, :test], runtime: false},

      # http
      {:bandit, "~> 1.12"},
      {:plug, "~> 1.20"},
      {:jason, "~> 1.4"},
      {:req, "~> 0.7.4"},
      {:corsica, "~> 2.1"},

      # auth
      {:bcrypt_elixir, "~> 3.0"},
      {:guardian, "~> 2.5"},

      # data
      {:ecto, "~> 3.14"},
      {:ecto_sql, "~> 3.14"},
      {:postgrex, "~> 0.22.4"},
      {:supra, "~> 4.0"},
      {:flop, "~> 0.29.0"},
      {:oban, "~> 2.23"}
    ]
  end
end
