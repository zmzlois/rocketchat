defmodule Rocketchat.Repo.Migrations.AddImagesToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :image_key, :string
    end
  end
end
