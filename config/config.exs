import Config

# default config, always gets loaded

config :smonify, ecto_repos: [Smonify.Repo]
config :smonify, Smonify.Repo, migration_timestamps: [type: :utc_datetime_usec]

# loads specific config, overwrites if already exists
import_config "#{config_env()}.exs"
