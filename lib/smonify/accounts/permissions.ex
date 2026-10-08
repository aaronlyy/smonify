defmodule Smonify.Accounts.Permissions do
  @moduledoc false

  alias Smonify.Accounts.User

  @permissions %{
    user: [],
    moderator: [:delete_any_link, :deactivate_account, :activate_account, :register_account],
    admin: [
      :create_any_link,
      :delete_any_link,
      :deactivate_account,
      :activate_account,
      :delete_account,
      :register_account
    ]
  }

  # needs defdelegate i think to call can?/2 from other modules although its a context function
  def can?(%User{role: role}, permission) do
    permission in Map.get(@permissions, role)
  end
end
