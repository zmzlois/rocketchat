defmodule RocketchatWeb.OrderHtml do
  use RocketchatWeb, :html

  def show(assigns) do
    ~H"""
    <.header>
      Thank you for your order!
      <:subtitle>
        <strong>User uuid: </strong><%= @order.user_uuid %>
      </:subtitle>
    </.header>

    <.table id="items" rows={@order.line_items}>
      <:col :let={item} label="Title"><%= item.product.title %></:col>
      <:col :let={item} label="Quantity"><%= item.quantity %></:col>
      <:col :let={item} label="Price">
        <%= RocketchatWeb.CartHtml.currency_to_str(item.price) %>
      </:col>
    </.table>

    <strong>Total price:</strong>
    <%= RocketchatWeb.CartHtml.currency_to_str(@order.total_price) %>

    <.back navigate={~p"/products"}>Back to products</.back>
    """
  end
end
