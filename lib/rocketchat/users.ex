defmodule Rocketchat.Users do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query, warn: false
  alias Rocketchat.Users.User

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking like changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
