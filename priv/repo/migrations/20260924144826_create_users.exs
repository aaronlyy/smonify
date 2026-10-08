defmodule Smonify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do

    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :role, :string, null: false, default: "user"
      add :password_hash, :string, null: false
      add :active, :bool, null: false, default: true
      add :failed_login_attempts, :integer, null: false, default: 0
      add :locked_until, :utc_datetime_usec
      add :display_name, :string
      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])

  end
end
