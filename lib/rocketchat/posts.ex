defmodule Rocketchat.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Rocketchat.Users
  alias Ecto.Changeset
  alias Rocketchat.Repo

  alias Rocketchat.Posts.Post

  def list_posts do
    Repo.all(from p in Post, order_by: [desc: p.inserted_at, asc: p.id])
    |> Repo.preload([:likes, :user, :quotes, quoted_post: [:user]])
  end

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
    with {:ok, post} <-
           %Post{}
           |> change_post(attrs)
           |> Changeset.put_assoc(:user, attrs.user)
           |> Changeset.put_assoc(:quoted_post, attrs[:quoted_post])
           |> Repo.insert() do
      {:ok, Repo.preload(post, :quoted_post)}
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

  alias Rocketchat.Posts.Repost

  @doc """
  Gets a single repost.

  Raises `Ecto.NoResultsError` if the Repost does not exist.

  ## Examples

      iex> get_repost!(123)
      %Repost{}

      iex> get_repost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repost!(id), do: Repo.get!(Repost, id)

  @doc """
  Creates a repost.

  ## Examples

      iex> create_repost(%{field: value})
      {:ok, %Repost{}}

      iex> create_repost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repost(attrs \\ %{}) do
    %Repost{}
    |> change_repost(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a repost.

  ## Examples

      iex> delete_repost(repost)
      {:ok, %Repost{}}

      iex> delete_repost(repost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repost(%Repost{} = repost) do
    Repo.delete(repost)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repost changes.

  ## Examples

      iex> change_repost(repost)
      %Ecto.Changeset{data: %Repost{}}

  """
  def change_repost(%Repost{} = repost, attrs \\ %{}) do
    Repost.changeset(repost, attrs)
  end
end
