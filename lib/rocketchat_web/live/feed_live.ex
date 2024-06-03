defmodule RocketchatWeb.FeedLive do
  use RocketchatWeb, :live_view

  import RocketchatWeb.FeedComponents

  def render(assigns) do
    IO.inspect(assigns.current_user, label: "current_user in render/1")

    ~H"""
    <div class="flex flex-col justify-center items-center h-screen bg-[#222222]">
      <!-- Mobile View -->
      <div class="max-w-96 min-h-[80vh] max-h-[80vh] bg-gray-50 relative overflow-y-scroll hide-scrollbar">
        <.top_header tab={@tab} />

        <.new_message_box />
        <!-- Content -->
        <div class="flex flex-col gap-2 bg-[#f2f2f2]">
          <.chat_item author_name="John" />
          <.chat_item author_name="Maria" />
          <.chat_item author_name="Joshua" />
        </div>

        <.bottom_navbar />
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user, label: "current_user in mount/3")

    tab = :fyp
    temperature = 70

    socket = assign(socket, :temperature, temperature)
    socket = assign(socket, :tab, tab)

    {:ok, socket, layout: false}
  end

  def handle_event("switch_tabs", %{"tab" => "fyp"}, socket) do
    IO.inspect("switching tab to fyp")

    {:noreply, update(socket, :tab, fn _ -> :fyp end)}
  end

  def handle_event("switch_tabs", %{"tab" => "following"}, socket) do
    IO.inspect("switching tab to following")

    {:noreply, update(socket, :tab, fn _ -> :following end)}
  end
end
