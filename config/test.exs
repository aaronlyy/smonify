import Config

config :smonify, Smonify.Repo,
  hostname: "localhost",
  port: 5432,
  username: "dev",
  password: "secret",
  database: "smonify_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :logger, level: :warning