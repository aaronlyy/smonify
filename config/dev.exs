import Config

config :smonify, Smonify.Repo,
  hostname: "localhost",
  port: 5432,
  username: "dev",
  password: "secret",
  database: "smonify_dev",
  pool_size: 10,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true
