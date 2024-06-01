defmodule Rocketchat.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :name, :string
    field :direct_message?, :boolean, default: false

    many_to_many :users, Rocketchat.Users.User, join_through: "user_chats"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name, :direct_message?])
    |> validate_required([:name, :direct_message?])
  end
end
