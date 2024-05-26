defmodule RocketchatWeb.ThermostatLive do
  use RocketchatWeb, :live_view

  import RocketchatWeb.LiveHelpers

  @impl true
  def mount(_params, session, socket) do
    current_user = get_user(socket, session)
    socket = assign(socket, :current_user, current_user)

    temperature = 70
    {:ok, assign(socket, :temperature, temperature)}
  end

  @impl true
  def handle_event("inc_temperature", _params, socket) do
    _current_user = socket.assigns.current_user

    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    Current Temperature: <%= @temperature %>°F
    <button phx-click="inc_temperature" class="bg-red-200 w-6 rounded-full aspect-square">+</button>
    """
  end
end
