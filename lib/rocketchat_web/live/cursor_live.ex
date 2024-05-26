defmodule RocketchatWeb.CursorLive do
  use RocketchatWeb, :live_view
  alias RocketchatWeb.Presence

  @channel_topic "cursor_page"

  @impl true
  def mount(_params, _session, socket) do
    username = get_username(socket.assigns.current_user)

    Presence.track(
      self(),
      @channel_topic,
      socket.id,
      %{socket_id: socket.id, x: 0, y: 0, username: username}
    )

    RocketchatWeb.Endpoint.subscribe(@channel_topic)

    users = get_users()

    {:ok, socket |> assign(:users, users)}
  end

  @impl true
  def handle_event("mouse-move", %{"x" => x, "y" => y}, socket) do
    key = socket.id
    payload = %{x: x, y: y}

    meta =
      with %{metas: [meta | _]} <- Presence.get_by_key(@channel_topic, key) do
        Map.merge(meta, payload)
      else
        _ -> payload
      end

    Presence.update(self(), @channel_topic, key, meta)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    users = get_users()
    {:noreply, socket |> assign(users: users)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <ul
      class="h-96 w-full group bg-neutral-200 overflow-hidden list-none"
      phx-hook="mouse-move"
      id="cursor-board"
    >
      <svg class="sr-only">
        <defs>
          <symbol
            xmlns="http://www.w3.org/2000/svg"
            width="31"
            height="32"
            fill="none"
            viewBox="0 0 31 32"
            id="cursor"
          >
            <path
              fill="url(#grad)"
              d="m.609 10.86 5.234 15.488c1.793 5.306 8.344 7.175 12.666 3.612l9.497-7.826c4.424-3.646 3.69-10.625-1.396-13.27L11.88 1.2C5.488-2.124-1.697 4.033.609 10.859Z"
            />
          </symbol>
          <linearGradient
            id="grad"
            x1="-4.982"
            x2="23.447"
            y1="-8.607"
            y2="25.891"
            gradientUnits="userSpaceOnUse"
          >
            <stop style="stop-color: #5B8FA3" />
            <stop offset="1" stop-color="#BDACFF" />
          </linearGradient>
        </defs>
      </svg>
      <%= for user <- @users do %>
        <li
          style={"transform: translate(#{user.x}px, #{user.y}px);"}
          class="absolute flex flex-col pointer-events-none whitespace-nowrap"
        >
          <svg class="size-8"><use href="#cursor" /></svg>
          <span><%= user.username %></span>
        </li>
      <% end %>
    </ul>
    """
  end

  defp get_username(%Rocketchat.Users.User{email: email}) do
    case Regex.run(~r/(.+)@/, email) do
      [_, match] -> match
      _ -> "anon"
    end
  end

  defp get_users() do
    Presence.list(@channel_topic)
    |> Enum.map(fn {_, %{metas: meta}} -> List.last(meta) end)
  end
end
