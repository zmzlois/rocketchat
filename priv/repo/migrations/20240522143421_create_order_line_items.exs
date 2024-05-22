defmodule Rocketchat.Repo.Migrations.CreateOrderLineItems do
  use Ecto.Migration

  def change do
    create table(:order_line_items) do
      add :price, :decimal, precision: 15, scale: 6, null: false
      add :quantity, :integer
      add :order_id, references(:orders, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:order_line_items, [:order_id])
    create index(:order_line_items, [:product_id])
  end
end
