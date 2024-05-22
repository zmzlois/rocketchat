defmodule Rocketchat.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :user_uuid, Ecto.UUID
    field :total_price, :decimal

    has_many :line_items, Rocketchat.Orders.LineItem
    has_many :products, through: [:line_items, :product]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_uuid, :total_price])
    |> validate_required([:user_uuid, :total_price])
  end
end
