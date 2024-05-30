defmodule Rocketchat.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    belongs_to :user, Rocketchat.Users.User

    field :content
    field :summary
    field :topic
    field :audio_key

    timestamps type: :utc_datetime

    has_many :likes, Rocketchat.Posts.Like
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [])
    |> validate_required([])
  end
end
