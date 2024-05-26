defmodule RocketchatWeb.FeedLive do
  use RocketchatWeb, :live_view

  def render(assigns) do
    IO.inspect(assigns.current_user, label: "current_user in render/1")
    ~H"""
    Current Temperature: <%= @temperature %>°F 
    <button phx-click="inc_temperature" class="bg-red-200 rounded-lg border border-red-100">+</button>
    <div class="w-full flex justify-center items-center">
      <div class="w-3/12 bg-red-200">
        
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user, label: "current_user in mount/3")

    temperature = 70
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do 
    IO.inspect(socket.assigns.current_user, label: "current_user in handle_event/3")

    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
