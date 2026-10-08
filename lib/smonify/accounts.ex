defmodule Smonify.Accounts do
  @moduledoc false

  defdelegate can?(user, permission), to: Smonify.Accounts.Permissions

  def test() do
    can?(%Smonify.Accounts.User{role: :admin}, :delete_any_link)
  end
end
