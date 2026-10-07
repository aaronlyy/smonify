defmodule Smonify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :role, :string, null: false, default: "user"
      add :password_hash, :string, null: false
      add :display_name, :string
      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
    
  end
end
