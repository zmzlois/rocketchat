defmodule Rocketchat.Repo.Migrations.AddPostQuotes do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :quoted_post_id, references(:posts, on_delete: :nilify_all, on_update: :update_all)
    end
  end
end
