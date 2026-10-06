defmodule Smonify.Repo.Migrations.CreateClicks do
  use Ecto.Migration

  def change do
    create table(:clicks) do
      add :user_agent, :text
      add :link_id, references(:links, on_delete: :delete_all), null: false
      timestamps(updated_at: false)
    end

    create index(:clicks, [:link_id])

  end
end
