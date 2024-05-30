defmodule RocketchatWeb.IndexLive do
  use RocketchatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Rocketchat</h1>
      <.flash_group flash={@flash} />
      <.live_component module={RocketchatWeb.RecordButton} id="audio-recorder" />
    </div>
    """
  end
end
