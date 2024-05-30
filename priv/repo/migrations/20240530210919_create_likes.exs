defmodule Rocketchat.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all),
        primary_key: true,
        null: false

      add :post_id, references(:posts, on_delete: :delete_all, on_update: :update_all),
        primary_key: true,
        null: false

      add :hidden?, :boolean, default: false, null: false

      timestamps type: :utc_datetime
    end
  end
end
