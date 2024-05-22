defmodule RocketchatWeb.CartHtml do
  alias Rocketchat.ShoppingCart
  use RocketchatWeb, :html

  def show(assigns) do
    ~H"""
    <%= case @cart.items do %>
      <% [] -> %>
        <.header>
          My Cart
          <:subtitle>Your cart is empty</:subtitle>
        </.header>
      <% _ -> %>
        <.header>
          My Cart
        </.header>

        <.simple_form :let={f} for={@changeset} action={~p"/cart"}>
          <.inputs_for :let={item_form} field={f[:items]}>
            <% item = item_form.data %>
            <.input field={item_form[:quantity]} type="number" label={item.product.title} />
            <%= currency_to_str(ShoppingCart.total_item_price(item)) %>
          </.inputs_for>
          <:actions>
            <.button>Update cart</.button>
          </:actions>
        </.simple_form>

        <b>Total</b>: <%= currency_to_str(ShoppingCart.total_cart_price(@cart)) %>
        <.back navigate={~p"/products"}>Back to products</.back>
    <% end %>
    """
  end

  defp currency_to_str(val = %Decimal{}), do: "$#{Decimal.round(val, 2)}"
end
