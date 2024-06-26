defmodule RocketchatWeb.Router do
  use RocketchatWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RocketchatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_assent_routes()
  end

  scope "/", RocketchatWeb do
    pipe_through [:browser, :protected]

    live_session :user, on_mount: RocketchatWeb.Setup.Authorized do
      live "/", IndexLive
      live "/feed", FeedLive

      live "/feed_test", FeedTestLive
      live "/speech_test", SpeechTestLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", RocketchatWeb do
  #   pipe_through :api
  # end

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
end
