defmodule RocketchatWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.Component

  alias Pow.Store.CredentialsCache
  alias Pow.Store.Backend.EtsCache

  def on_mount(:default, _params, session, socket) do
    IO.inspect("here")
    socket =
      assign_new(socket, :current_user, fn ->
        get_user(socket, session)
      end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end

  def get_user(socket, session, config \\ [otp_app: :rocketchat])

  def get_user(socket, %{"rocketchat_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _metadata} <- CredentialsCache.get([backend: EtsCache], token) do
      user
    else
      _ -> nil
    end
  end

  def get_user(_, _, _), do: nil
end
