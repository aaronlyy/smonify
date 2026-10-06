defmodule Smonify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    
    create table(:accounts) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :display_name, :string
      timestamps()
    end

    create unique_index(:accounts, [:username])
    create unique_index(:accounts, [:email])
    
  end
end
