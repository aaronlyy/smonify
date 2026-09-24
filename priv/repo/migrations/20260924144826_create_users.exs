defmodule Smonify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do

    add :email, string, null: false
    add :password_hash, string, null: false

  end
end
