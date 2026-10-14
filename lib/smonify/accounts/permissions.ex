defmodule Smonify.Accounts.Permissions do
  @moduledoc false

  alias Smonify.Accounts.User

  @ranks %{user: 0, moderator: 1, admin: 2}

  @permissions %{
    user: [
      # create link with own user as owner
      :create_own_link,
      # delete links where owner is own user
      :delete_own_link,
      # get list of own links
      :get_own_links,
      # get clicks of own link
      :get_own_link_clicks,
      # delete own user
      :delete_own_user
    ],
    moderator: [
      # get links of any user
      :get_any_links,
      # get link clicks of any user
      :get_any_link_clicks,
      # delete links of any user
      :delete_any_link,
      # deactivate any user
      :deactivate_any_user,
      # activate any user
      :activate_any_user
    ],
    admin: [
      # delete any user
      :delete_any_user
    ]
  }

  # permissions are inherited from lower roles
  @effective_permissions (for {role, rank} <- @ranks, into: %{} do
                            perms =
                              for {other_role, other_rank} <- @ranks,
                                  other_rank <= rank,
                                  perm <- @permissions[other_role],
                                  do: perm

                            {role, MapSet.new(perms)}
                          end)

  def can?(%User{active: false}, _permissions), do: false

  def can?(%User{role: role}, permission) do
    role
    |> then(&Map.get(@effective_permissions, &1, MapSet.new()))
    |> MapSet.member?(permission)
  end

  def outranks?(%User{role: role_a}, %User{role: role_b}), do: @ranks[role_a] > @ranks[role_b]
end
