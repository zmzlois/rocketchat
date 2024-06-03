defmodule Rocketchat.Repo.Migrations.CreateUserChats do
  use Ecto.Migration

  def change do
    create table(:user_chats, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all),
        primary_key: true,
        null: false

      add :chat_id, references(:chats, on_delete: :delete_all, on_update: :update_all),
        primary_key: true,
        null: false

      timestamps(type: :utc_datetime)
    end
  end
end
