defmodule Smonify.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :text, null: false
      add :code, :string, null: false
      add :clicks, :integer, null: false, default: 0
      add :account_id, references(:accounts, on_delete: :delete_all), null: false

      timestamps()
    end

  end
end
