defmodule RocketchatWeb.FeedLive do
  use Phoenix.LiveView

  import RocketchatWeb.LiveHelpers

  def render(assigns) do
    ~H"""
    Current Temperature: <%= @temperature %>°F 
    <button phx-click="inc_temperature" class="bg-red-200 rounded-lg border border-red-100">+</button>
    <div class="w-full flex justify-center items-center">
      <div class="w-3/12 bg-red-200">
        
      </div>
    </div>
    """
  end

  def mount(_params, session, socket) do
    current_user = get_user(socket, session)
    socket = assign(socket, :current_user, current_user)

    temperature = 70
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do 
    current_user = socket.assigns.current_user

    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
