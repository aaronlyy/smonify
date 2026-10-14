defmodule Smonify.Links do
  @moduledoc false

  import Ecto.Query

  alias Smonify.Accounts
  alias Smonify.Accounts.User
  alias Smonify.Links.{Link, Click}
  alias Smonify.Repo

  @random_code_length 8

  # generates a random code with given length
  def generate_random_code(length \\ @random_code_length) do
    # one byte needs 5 bits in base32, so we multiply by 5 and add 7 so we always have enough, then divide by 8
    bytes = div(length * 5 + 7, 8)

    # create true random bytes using erlangs :crypto module
    :crypto.strong_rand_bytes(bytes)
    # we want lowercase codes and no added ==
    |> Base.encode32(case: :lower, padding: false)
    # extract the string
    |> binary_part(0, length)
  end

  def create_link(%User{} = actor, url, code \\ nil) do
    if Accounts.can?(actor, :create_own_link) do
      actor
      # build relation between link and owning
      |> Ecto.build_assoc(:links)
      |> Link.create_changeset(%{url: url, code: code || generate_random_code()})
      |> Repo.insert()
    else
      {:error, :unauthorized}
    end
  end

  # deletes a link if actor is the owner
  def delete_link(%User{} = actor, %Link{} = link) do
    permission = if actor.id == link.user_id, do: :delete_own_link, else: :delete_any_link

    if Accounts.can?(actor, permission) do
      link
      |> Repo.delete()
    else
      {:error, :unauthorized}
    end
  end

  def list_links(%User{} = actor), do: list_links(actor, actor)

  def list_links(%User{} = actor, %User{} = target) do
    permission = if actor.id == target.id, do: :get_own_links, else: :get_any_links

    if Accounts.can?(actor, permission) do
      {:ok, Repo.all(from l in Link, where: l.user_id == ^target.id)}
    else
      {:error, :unauthorized}
    end
  end

  def get_clicks(%User{} = actor, %Link{} = link) do
    permission = if actor.id == link.user_id, do: :get_own_link_clicks, else: :get_any_link_clicks

    if Accounts.can?(actor, permission) do
      {:ok, Repo.all(from c in Click, where: c.link_id == ^link.id)}
    else
      {:error, :unauthorized}
    end
  end

  def create_click(%Link{} = link, user_agent, ip_address) do
    link
    |> Ecto.build_assoc(:clicks)
    |> Click.create_changeset(%{user_agent: user_agent, ip_address: ip_address})
    |> Repo.insert()
  end

  def get_link_by_code(code) do
    case Repo.get_by(Link, code: code) do
      nil -> {:error, :not_found}
      link -> {:ok, link}
    end
  end
end
