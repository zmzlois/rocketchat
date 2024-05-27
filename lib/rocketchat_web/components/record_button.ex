defmodule RocketchatWeb.RecordButton do
  use RocketchatWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket |> allow_upload(:audio, accept: ~w"audio/*"), layout: false}
  end

  @impl true
  def handle_event("recorded", _params, socket) do
    IO.puts("recorded")

    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    IO.inspect("save")
    socket.assigns.uploads.audio.entries |> IO.inspect()

    {:noreply, socket}
  end

  def handle_event(e, _params, socket) do
    IO.inspect({e})

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form phx-submit="save" phx-target={@myself}>
      <button type="button" phx-hook="record-audio" id="audio-recorder">
        record
      </button>
      <.live_file_input upload={@uploads.audio} phx-change="recorded" class="sr-only" />
    </form>
    """
  end
end
