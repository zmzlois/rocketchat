defmodule Rocketchat.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Rocketchat.Users
  alias Ecto.Changeset
  alias Rocketchat.Repo

  alias Rocketchat.Posts.Post

  # todo
  def list_posts do
    []
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
end
