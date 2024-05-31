# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rocketchat.Repo.insert!(%Rocketchat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rocketchat.Repo

# todo - created_at should be random, not now

defmodule Seed do
  alias Rocketchat.{Users, Posts}

  def seed do
    seed_users(50)

    post_count = 500
    seed_posts(post_count)
    seed_likes(post_count * 5)
    seed_reposts(post_count * 2)
    seed_quotes(post_count)
  end

  defp seed_users(count) when is_integer(count) do
    for _ <- 1..count do
      %Users.User{email: Faker.Internet.email()}
    end
    |> insert_all()

    DataProvider.update(Users.User)
  end

  defp seed_posts(count) when is_integer(count) do
    for _ <- 1..count do
      %Posts.Post{
        user: DataProvider.get_random_row(Users.User),
        content: Faker.Lorem.paragraph(),
        summary: maybe(&Faker.Lorem.paragraph/0),
        audio_key: Faker.UUID.v4(),
        topic: maybe(&Faker.Company.buzzword/0)
      }
    end
    |> insert_all()

    DataProvider.update(Posts.Post)
  end

  defp seed_likes(count) when is_integer(count) do
    for _ <- 1..count do
      %Posts.Like{
        user: DataProvider.get_random_row(Users.User),
        post: DataProvider.get_random_row(Posts.Post)
      }
    end
    |> insert_all(on_conflict: :nothing)
  end

  defp seed_reposts(count) when is_integer(count) do
    for _ <- 1..count do
      %Posts.Repost{
        user: DataProvider.get_random_row(Users.User),
        post: DataProvider.get_random_row(Posts.Post)
      }
    end
    |> insert_all(on_conflict: :nothing)
  end

  defp seed_quotes(count) when is_integer(count) do
    for _ <- 1..count do
      %Posts.Post{create_post() | quoted_post: DataProvider.get_random_row(Posts.Post)}
    end
    |> insert_all()

    DataProvider.update(Posts.Post)
  end

  defp create_post do
    %Posts.Post{
      user: DataProvider.get_random_row(Users.User),
      content: Faker.Lorem.paragraph(),
      summary: maybe(&Faker.Lorem.paragraph/0),
      audio_key: Faker.UUID.v4(),
      topic: maybe(&Faker.Company.buzzword/0)
    }
  end

  defp maybe(generator) when is_function(generator) do
    case Faker.random_between(0, 1) do
      0 -> nil
      1 -> generator.()
    end
  end

  @doc """
  Given a list of structs will insert them into the database - each as a separate statement.
  Each statement will spawn a separate task and then the result of each task is returned as a list.

  ## Options
  The same ones accepted by `Repo.insert/2`
  """

  def insert_all(values, opts \\ []) do
    values
    |> Task.async_stream(&Repo.insert!(&1, opts))
    |> Enum.to_list()
  end
end

defmodule DataProvider do
  @doc """
  Refetches all rows for the specified schema
  """
  def update(repo) when is_atom(repo) do
    ensure_provider_started(repo)

    Agent.update(repo, fn _ -> Repo.all(repo) end)
  end

  @doc """
  Fetches a single random row from specified schema or nil if there are none
  """
  def get_random_row(repo) when is_atom(repo) do
    ensure_provider_started(repo)
    Agent.get(repo, &random/1)
  end

  defp ensure_provider_started(repo) when is_atom(repo) do
    if !Process.whereis(repo) do
      Agent.start_link(fn -> Repo.all(repo) end, name: repo)
    end
  end

  defp random(enum) do
    case enum do
      [] -> nil
      v -> Enum.random(v)
    end
  end
end

Seed.seed()
