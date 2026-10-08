defmodule Smonify.Links.Click do
  @moduledoc false

  use Smonify.Schema

  import Ecto.Changeset

  schema "clicks" do
    field :user_agent, :string
    field :ip_address, EctoNetwork.INET

    belongs_to :link, Smonify.Links.Link

    timestamps(updated_at: false)
  end

  def create_changeset(click, params \\ %{}) do
    click
    |> cast(params, [:user_agent, :ip_address])
    |> validate_length(:user_agent, max: 4096)
    # we need validate ip or something
    |> assoc_constraint(:link)
  end
end
