defmodule RocketchatWeb.Router do
  use RocketchatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RocketchatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_cart
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RocketchatWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/products", ProductController

    resources "/cart_items", CartItemController, only: [:create, :delete]
    get "/cart", CartController, :show
    put "/cart", CartController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", RocketchatWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rocketchat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RocketchatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp fetch_current_user(conn, _opts) do
    case get_session(conn, :current_uuid) do
      nil ->
        new_uuid = Ecto.UUID.generate()

        conn
        |> assign(:current_uuid, new_uuid)
        |> put_session(:current_uuid, new_uuid)

      uuid ->
        assign(conn, :current_uuid, uuid)
    end
  end

  defp fetch_current_cart(conn, _opts) do
    alias Rocketchat.ShoppingCart

    cart_id = conn.assigns.current_uuid

    if cart = ShoppingCart.get_cart_by_user_uuid(cart_id) do
      assign(conn, :cart, cart)
    else
      {:ok, new_cart} = ShoppingCart.create_cart(cart_id)
      assign(conn, :cart, new_cart)
    end
  end
end
