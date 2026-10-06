defmodule Smonify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :username, :string
      add :email, :string, null: false
      add :password_hash, :string, null: false
      timestamps()
    end
  end
end
