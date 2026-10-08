defmodule Smonify.Accounts do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Smonify.Accounts.{Permissions, User}
  alias Smonify.Repo

  @max_failed_attempts 5
  @lock_duration_minutes 15

  defdelegate can?(user, permission), to: Permissions

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(username, password)
      when is_binary(username) and is_binary(password) do
    with {:ok, user} <- fetch_user(username),
         :ok <- check_active(user),
         :ok <- check_not_locked(user),
         :ok <- verify_password(user, password) do
      reset_failed_login_attempts(user)
    else
      {:error, :not_found} ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}

      {:error, {:invalid_password, user}} ->
        register_failed_login(user)
        {:error, :invalid_credentials}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def authenticate_user(_username, _password), do: {:error, :invalid_credentials}

  # TODO
  def delete_user do
  end

  # TODO
  def deactivate_user do
  end

  # TODO
  def activate_user do
  end

  # TODO
  def update_user do
  end

  # fetch user
  defp fetch_user(username) do
    case Repo.get_by(User, username: String.downcase(username)) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  defp check_active(%User{active: true}), do: :ok
  defp check_active(%User{}), do: {:error, :inactive}

  defp check_not_locked(%User{locked_until: nil}), do: :ok

  defp check_not_locked(%User{locked_until: locked_until}) do
    if DateTime.after?(locked_until, DateTime.utc_now()) do
      {:error, :locked}
    else
      :ok
    end
  end

  defp verify_password(%User{password_hash: password_hash} = user, password) do
    if Bcrypt.verify_pass(password, password_hash) do
      :ok
    else
      {:error, {:invalid_password, user}}
    end
  end

  defp reset_failed_login_attempts(%User{failed_login_attempts: 0, locked_until: nil} = user),
    do: {:ok, user}

  defp reset_failed_login_attempts(user) do
    user
    |> Ecto.Changeset.change(failed_login_attempts: 0, locked_until: nil)
    |> Repo.update()
  end

  defp register_failed_login(user) do
    {1, [attempts]} =
      from(u in User, where: u.id == ^user.id, select: u.failed_login_attempts)
      |> Repo.update_all(inc: [failed_login_attempts: 1])

    if attempts >= @max_failed_attempts do
      locked_until = DateTime.add(DateTime.utc_now(), @lock_duration_minutes, :minute)

      from(u in User, where: u.id == ^user.id)
      |> Repo.update_all(set: [failed_login_attempts: 0, locked_until: locked_until])
    end
  end
end
