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

defmodule Seed do
  def seed do
    seed_users(50)

    post_count = 500
    seed_posts(post_count)
    seed_likes(post_count * 5)
  end

  defp seed_users(count) when is_integer(count) do
    for(
      _ <- 1..count,
      do: %Rocketchat.Users.User{
        email: Faker.Internet.email()
      }
    )
    |> insert_all()
  end

  defp seed_posts(count) when is_integer(count) do
    get_random_user = random_entity_generator(Rocketchat.Users.User)

    for(
      _ <- 1..count,
      do: %Rocketchat.Posts.Post{
        author_id: get_random_user.().id,
        content: Faker.Lorem.paragraph(),
        summary: maybe(&Faker.Lorem.paragraph/0),
        audio_key: Faker.UUID.v4(),
        topic: maybe(&Faker.Company.buzzword/0)
      }
    )
    |> insert_all()
  end

  defp seed_likes(count) when is_integer(count) do
    get_random_user = random_entity_generator(Rocketchat.Users.User)
    get_random_post = random_entity_generator(Rocketchat.Posts.Post)

    for(
      _ <- 1..count,
      do: %Rocketchat.Posts.Like{
        user: get_random_user.(),
        post: get_random_post.()
      }
    )
    |> insert_all(on_conflict: :nothing)
  end

  defp maybe(generator) when is_function(generator) do
    case Faker.random_between(0, 1) do
      0 -> nil
      1 -> generator.()
    end
  end

  defp random_entity_generator(entity) do
    entities = Repo.all(entity)
    fn -> Enum.random(entities) end
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

Seed.seed()
