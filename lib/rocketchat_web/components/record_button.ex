defmodule RocketchatWeb.RecordButton do
  use RocketchatWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket |> allow_upload(:audio, accept: ~w"audio/*", auto_upload: true), layout: false}
  end

  @impl true
  def handle_event("recorded", _params, socket) do
    consume_uploaded_entries(socket, :audio, fn
      %{path: path}, %Phoenix.LiveView.UploadEntry{client_name: name} ->
        IO.inspect({path, name})
        {:ok, nil}
    end)

    {:noreply, socket}
  end

  def handle_event(e, _params, socket) do
    IO.inspect({e})

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form phx-submit="recorded" phx-target={@myself}>
      <button
        id="audio-recorder"
        type="button"
        phx-hook="record-audio"
        data-upload-name={@uploads.audio.name}
      >
        record
      </button>
      <%!-- doesn't work w/o phx-change ¯\_(ツ)_/¯ --%>
      <.live_file_input upload={@uploads.audio} phx-change="_" class="sr-only" />
    </form>
    """
  end
end
