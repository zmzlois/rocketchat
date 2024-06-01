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
    alias Rocketchat.Posts.Repost
    alias Users.User

    posts_query =
      from p in Post,
        select: %{p | reposted_by: nil, posted_at: p.inserted_at}

    reposts_query =
      from r in Repost,
        inner_join: p in Post,
        on: r.post_id == p.id,
        inner_join: u in User,
        on: r.author_id == u.id,
        select: %{p | reposted_by: u.email, posted_at: r.inserted_at}

    union_query =
      from p in posts_query,
        union_all: ^reposts_query

    from(p in subquery(union_query),
      order_by: [desc: p.posted_at, asc: p.id]
    )
    |> Repo.all()
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
  def create_repost(attrs = %{user: %Users.User{}, post: %Post{}}) do
    with {:ok, repost} <-
           Ecto.build_assoc(attrs.post, :reposts)
           |> change_repost(attrs)
           |> Changeset.put_assoc(:user, attrs.user)
           |> Repo.insert() do
      {:ok, Repo.preload(repost, post: [:user])}
    end
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
