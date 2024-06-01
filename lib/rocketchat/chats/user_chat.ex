defmodule Rocketchat.Chats.UserChat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "user_chats" do
    belongs_to :user, Rocketchat.Users.User, primary_key: true
    belongs_to :chat, Rocketchat.Chats.Chat, primary_key: true

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [])
    |> validate_required([])
  end
end
