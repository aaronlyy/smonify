defmodule Smonify.Accounts.User do
  @moduledoc false

  use Smonify.Schema

  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :role, Ecto.Enum, values: [:user, :moderator, :admin], default: :user
    field :password, :string, virtual: true, redact: true
    field :active, :boolean, default: true
    field :failed_login_attempts, :integer, default: 0
    field :locked_until, :utc_datetime_usec
    field :password_hash, :string, redact: true
    field :display_name, :string

    has_many :links, Smonify.Links.Link

    timestamps()
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password, :email, :display_name])
    |> validate_required([:username, :password, :email])
    |> validate_length(:email, min: 3, max: 254)
    |> validate_length(:username, min: 3, max: 32)
    |> validate_length(:display_name, min: 3, max: 32)
    |> validate_length(:password, min: 8, max: 72, count: :bytes)
    |> update_change(:username, &String.downcase/1)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> hash_password()
  end

  # update user information
  def update_info_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:display_name])
    |> validate_length(:display_name, min: 3, max: 32)
  end

  # activate or deactivate an user
  def active_changeset(user, params \\ %{}) do
    user
    |> cast(params, [:active])
    |> validate_required([:active])
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  defp hash_password(changeset), do: changeset
end
