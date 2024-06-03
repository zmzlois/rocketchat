defmodule RocketchatWeb.SpeechTestLive do
  alias RocketchatWeb.Services.OpenaiService
  use RocketchatWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(transcription: nil)
     |> assign(summary: nil)}
  end

  def handle_info({:transcription_done, transcription}, socket) do
    {:noreply,
     socket
     |> assign(:transcription, transcription)}
  end

  def handle_info({:summary_done, summary}, socket) do
    {:noreply,
     socket
     |> assign(:summary, summary)}
  end

  defp handle_recording(file) do
    transcription = file |> OpenaiService.transcribe!()
    notify_self(:transcription_done, transcription)

    summary = transcription |> OpenaiService.summarize!()
    notify_self(:summary_done, summary)
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 justify-center item-center size-full">
      <.live_component
        module={RocketchatWeb.RecordButton}
        id="audio-recorder"
        handle_recording={&handle_recording/1}
      />
      <div :if={@transcription} class="flex justify-center">
        <h3>Transcription:</h3>
        <%= @transcription %>
      </div>
      <div :if={@summary} class="flex justify-center flex-col">
        <h3>Summary:</h3>
        <%= @summary %>
      </div>
    </div>
    """
  end

  defp notify_self(event, message) do
    send(self(), {event, message})
  end
end
