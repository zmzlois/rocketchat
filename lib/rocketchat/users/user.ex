defmodule Rocketchat.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    timestamps()

    has_many :posts, Rocketchat.Posts.Post, foreign_key: :author_id
    has_many :reposts, Rocketchat.Posts.Repost, foreign_key: :author_id
    has_many :likes, Rocketchat.Posts.Like
  end
end
