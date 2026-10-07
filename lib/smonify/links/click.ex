defmodule Smonify.Links.Click do
  @moduledoc false

  use Smonify.Schema

  import Ecto.Changeset

  schema "clicks" do
    field :user_agent, :string

    belongs_to :link, Smonify.Links.Link

    timestamps(updated_at: false)
  end

  def create_changeset(click, params \\ %{}) do
    click
    |> cast(params, [:user_agent])
    |> validate_length(:user_agent, max: 4096)
    |> assoc_constraint(:link)
  end
end
