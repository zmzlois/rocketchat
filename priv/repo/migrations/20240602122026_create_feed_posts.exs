defmodule Rocketchat.Repo.Migrations.CreateFeedPosts do
  use Ecto.Migration

  def change do
    create table(:feed_posts) do
      add :post_id, references(:posts, on_delete: :delete_all, on_update: :update_all),
        null: false

      add :posted_by, references(:users, on_delete: :delete_all, on_update: :update_all),
        null: false

      timestamps type: :utc_datetime
    end

    create unique_index(:feed_posts, [:post_id, :posted_by])
  end
end
