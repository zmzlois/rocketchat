defmodule Rocketchat.Posts.Like do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "likes" do
    belongs_to :post, Rocketchat.Posts.Post, primary_key: true
    belongs_to :user, Rocketchat.Users.User, primary_key: true

    field :hidden?, :boolean, default: false

    timestamps type: :utc_datetime
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:hidden?])
    |> validate_required([:hidden?])
    |> unique_constraint([:user, :post])
  end
end
