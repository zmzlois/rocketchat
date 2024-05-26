defmodule RocketchatWeb.CursorLive do
  use RocketchatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:x, 0)
     |> assign(:y, 0)
     |> assign(:username, get_username(socket.assigns.current_user))}
  end

  @impl true
  def handle_event("mouse-move", %{"x" => x, "y" => y}, socket) do
    {:noreply,
     socket
     |> assign(:x, x)
     |> assign(:y, y)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <ul
      class="h-96 w-full group bg-neutral-200 overflow-hidden list-none"
      phx-hook="mouse-move"
      data-move-throttle="100"
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
      <li
        style={"transform: translate(#{@x}px, #{@y}px);"}
        class="flex flex-col group-phx-hook-loading:transition-transform duration-75 pointer-events-none whitespace-nowrap"
      >
        <svg class="size-8"><use href="#cursor" /></svg>
        <span><%= @username %></span>
      </li>
    </ul>
    """
  end

  defp get_username(%Rocketchat.Users.User{email: email}) do
    case Regex.run(~r/(.+)@/, email) do
      [_, match] -> match
      _ -> "anon"
    end
  end
end
