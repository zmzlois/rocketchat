defmodule Rocketchat.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :author_id, references(:users), null: false

      add :content, :string, size: 2047, null: false
      add :summary, :string, size: 1023
      add :topic, :string
      add :audio_key, :string, null: false
      add :quoted_post_id, references(:posts, on_delete: :nilify_all, on_update: :update_all)

      timestamps(type: :utc_datetime)
    end
  end
end
