defmodule Rocketchat.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    belongs_to :user, Rocketchat.Users.User, foreign_key: :author_id
    belongs_to :quoted_post, Rocketchat.Posts.Post, foreign_key: :quoted_post_id

    field :content
    field :summary
    field :topic
    field :audio_key

    timestamps type: :utc_datetime

    has_many :feed_posts, Rocketchat.Posts.FeedPost
    has_many :likes, Rocketchat.Posts.Like
    has_many :quotes, Rocketchat.Posts.Post, foreign_key: :quoted_post_id
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :summary, :topic, :audio_key])
    |> validate_required([:content, :audio_key])
  end
end
