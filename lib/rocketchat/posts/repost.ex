defmodule Rocketchat.Posts.Repost do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "reposts" do
    belongs_to :post, Rocketchat.Posts.Post, primary_key: true
    belongs_to :user, Rocketchat.Users.User, primary_key: true, foreign_key: :author_id

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(repost, attrs) do
    repost
    |> cast(attrs, [])
    |> validate_required([])
  end
end
