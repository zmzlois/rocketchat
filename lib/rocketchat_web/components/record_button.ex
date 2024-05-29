defmodule RocketchatWeb.RecordButton do
  use RocketchatWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(recording?: false)
     |> allow_upload(:audio, accept: ~w"audio/*", auto_upload: true), layout: false}
  end

  @impl true
  def handle_event("recording", _params, socket) do
    {:noreply, socket |> assign(recording?: true)}
  end

  def handle_event("recorded", _params, socket) do
    {:noreply, socket |> assign(recording?: false)}
  end

  def handle_event("uploaded", _params, socket) do
    consume_uploaded_entries(socket, :audio, fn
      %{path: path}, %Phoenix.LiveView.UploadEntry{} ->
        dest_dir = Application.app_dir(:rocketchat, "priv/static/uploads/voice_message")
        :ok = File.mkdir_p(dest_dir)

        filename = Path.basename(path)
        dest = dest_dir |> Path.join(filename)
        File.cp!(path, dest)
        {:ok, nil}
    end)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form phx-submit="uploaded" phx-target={@myself} class="flex flex-col items-center p-2">
      <button
        id="audio-recorder"
        type="button"
        phx-hook="record-audio"
        data-upload-name={@uploads.audio.name}
        data-max-duration={5 * 60}
        class="font-bold uppercase text-2xl bg-red-400 text-white p-2 rounded-lg disabled:bg-neutral-400 transition-colors"
      >
        <%= if @recording? do %>
          recording
        <% else %>
          record
        <% end %>
      </button>
      <%!-- doesn't work w/o phx-change ¯\_(ツ)_/¯ --%>
      <.live_file_input upload={@uploads.audio} phx-change="recorded" class="sr-only" />
    </form>
    """
  end
end
