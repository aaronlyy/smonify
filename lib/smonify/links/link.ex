defmodule Smonify.Links.Link do
  @moduledoc false

  use Smonify.Schema

  import Ecto.Changeset

  schema "links" do
    field :url, :string
    field :code, :string

    has_many :clicks, Smonify.Links.Click
    belongs_to :user, Smonify.Accounts.User

    timestamps()
  end

  def create_changeset(link, params \\ %{}) do
    link
    |> cast(params, [:url, :code])
    |> validate_required([:url, :code])
    |> validate_url(:url)
    |> validate_length(:url, max: 2048)
    |> unique_constraint(:code)
    |> assoc_constraint(:user)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn ^field, url ->
      case URI.new(url) do
        {:ok, %URI{scheme: scheme, host: host}}
        when scheme in ["http", "https"] and is_binary(host) and host != "" ->
          []

        _ ->
          [{field, "must be a valid http or https URL"}]
      end
    end)
  end
end
