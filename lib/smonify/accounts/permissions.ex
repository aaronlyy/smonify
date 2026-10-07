defmodule Smonify.Accounts.Permissions do

  alias Smonify.Accounts.User

  @permissions %{
    user: [],
    moderator: [:delete_any_link, :deactivate_account, :activate_account, :register_account],
    admin: [:create_any_link, :delete_any_link, :deactivate_account, :activate_account, :delete_account, :register_account]
  }
  
	def can?(%User{role: role}, permission) do
	  permission in Map.fetch(@permissions, role)
	end
end