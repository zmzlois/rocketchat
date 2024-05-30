defmodule Rocketchat.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :author_id, references(:users), null: false

      add :content, :string, null: false
      add :summary, :string
      add :topic, :string
      add :audio_key, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
