defmodule Rocketchat.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :name, :string
      add :direct_message?, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
