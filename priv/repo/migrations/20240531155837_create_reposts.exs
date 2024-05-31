defmodule Rocketchat.Repo.Migrations.CreateReposts do
  use Ecto.Migration

  def change do
    create table(:reposts, primary_key: false) do
      add :author_id, references(:users, on_delete: :delete_all, on_update: :update_all),
        primary_key: true,
        null: false

      add :post_id, references(:posts, on_delete: :delete_all, on_update: :update_all),
        primary_key: true,
        null: false

      timestamps(type: :utc_datetime)
    end
  end
end
