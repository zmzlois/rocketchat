defmodule Rocketchat.Posts.FeedPost do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_posts" do
    belongs_to :post, Rocketchat.Posts.Post
    belongs_to :user, Rocketchat.Users.User, foreign_key: :posted_by

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(feed_post, attrs) do
    feed_post
    |> cast(attrs, [])
    |> validate_required([])
  end
end
