defmodule RocketchatWeb.ThermostatLive do
  use RocketchatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    temperature = 70
    {:ok, assign(socket, :temperature, temperature)}
  end

  @impl true
  def handle_event("inc_temperature", _params, socket) do
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
