defmodule Smonify.Repo do
  @moduledoc false
  use Ecto.Repo, otp_app: :smonify, adapter: Ecto.Adapters.Postgres
end
