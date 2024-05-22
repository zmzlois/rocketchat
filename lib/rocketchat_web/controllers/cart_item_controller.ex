defmodule RocketchatWeb.CartItemController do
  use RocketchatWeb, :controller

  alias Rocketchat.ShoppingCart

  def create(conn, %{"product_id" => product_id}) do
    case ShoppingCart.add_item_to_cart(conn.assigns.cart, product_id) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item added to your cart")
        |> redirect(to: ~p"/cart")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error adding the item to your cart")
        |> redirect(to: ~p"/cart")
    end
  end

  def delete(conn, %{"id" => product_id}) do
    {:ok, _cart} = ShoppingCart.remove_item_from_cart(conn.assigns.cart, product_id)
    redirect(conn, to: ~p"/cart")
  end
end
