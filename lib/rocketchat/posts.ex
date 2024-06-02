defmodule Rocketchat.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Rocketchat.Users
  alias Ecto.Changeset
  alias Rocketchat.Repo

  alias Rocketchat.Posts.Post

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs = %{user: %Users.User{}}) do
    quoted_post = attrs[:quoted_post]

    post =
      if quoted_post do
        Ecto.build_assoc(quoted_post, :quotes)
      else
        %Post{}
      end

    with {:ok, post} <-
           post
           |> change_post(attrs)
           |> Changeset.put_assoc(:user, attrs.user)
           |> Repo.insert() do
      {:ok, Repo.preload(post, quoted_post: [:user])}
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Rocketchat.Posts.Like

  @doc """
  Gets a single like.

  Raises `Ecto.NoResultsError` if the Like does not exist.

  ## Examples

      iex> get_like!(123)
      %Like{}

      iex> get_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_like!(id), do: Repo.get!(Like, id)

  @doc """
  Creates a like.

  ## Examples

      iex> create_like(%{field: value})
      {:ok, %Like{}}

      iex> create_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_like(attrs \\ %{}) do
    %Like{}
    |> change_like(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a like.

  ## Examples

      iex> delete_like(like)
      {:ok, %Like{}}

      iex> delete_like(like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking like changes.

  ## Examples

      iex> change_like(like)
      %Ecto.Changeset{data: %Like{}}

  """
  def change_like(%Like{} = like, attrs \\ %{}) do
    Like.changeset(like, attrs)
  end

  alias Rocketchat.Posts.FeedPost

  @doc """
  Returns the list of feed_posts.

  ## Examples

      iex> list_feed_posts()
      [%FeedPost{}, ...]

  """
  def list_feed_posts do
    Repo.all(FeedPost)
  end

  @doc """
  Gets a single feed_post.

  Raises `Ecto.NoResultsError` if the Feed post does not exist.

  ## Examples

      iex> get_feed_post!(123)
      %FeedPost{}

      iex> get_feed_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feed_post!(id), do: Repo.get!(FeedPost, id)

  @doc """
  Creates a feed_post.

  ## Examples

      iex> create_feed_post(%{field: value})
      {:ok, %FeedPost{}}

      iex> create_feed_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed_post(attrs \\ %{}) do
    %FeedPost{}
    |> change_feed_post(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a feed_post.

  ## Examples

      iex> update_feed_post(feed_post, %{field: new_value})
      {:ok, %FeedPost{}}

      iex> update_feed_post(feed_post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feed_post(%FeedPost{} = feed_post, attrs) do
    feed_post
    |> change_feed_post(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feed_post.

  ## Examples

      iex> delete_feed_post(feed_post)
      {:ok, %FeedPost{}}

      iex> delete_feed_post(feed_post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feed_post(%FeedPost{} = feed_post) do
    Repo.delete(feed_post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feed_post changes.

  ## Examples

      iex> change_feed_post(feed_post)
      %Ecto.Changeset{data: %FeedPost{}}

  """
  def change_feed_post(%FeedPost{} = feed_post, attrs \\ %{}) do
    FeedPost.changeset(feed_post, attrs)
  end
end
