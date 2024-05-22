defmodule RocketchatWeb.CartController do
  alias Rocketchat.ShoppingCart
  use RocketchatWeb, :controller

  plug :put_view, RocketchatWeb.CartHtml

  def show(conn, _params) do
    render(conn, :show, changeset: ShoppingCart.change_cart(conn.assigns.cart))
  end

  def update(conn, %{"cart" => cart_param}) do
    case ShoppingCart.update_cart(conn.assigns.cart, cart_param) do
      {:ok, _} ->
        conn

      {:error, _} ->
        conn |> put_flash(:error, "There was an error updating your cart")
    end
    |> redirect(to: ~p"/cart")
  end
end
