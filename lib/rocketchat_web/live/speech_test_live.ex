defmodule RocketchatWeb.SpeechTestLive do
  alias RocketchatWeb.Services.OpenaiService
  use RocketchatWeb, :live_view

  def render(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="prompt"
      class="flex flex-col gap-2 justify-center item-center size-full"
    >
      <div class="flex flex-col gap-5 justify-start">
        <div class="flex justify-center">
          <.input
            field={@form[:file_name]}
            type="select"
            label="Voice File"
            options={Enum.map(@files, & &1)}
            prompt="Select a voice file"
            required
          />
        </div>
        <div class="flex justify-center">
          <.input type="text" field={@form[:prompt_text]} label="Text to summerize" />
        </div>
      </div>
      <div class="flex justify-center">
        <button class="border-2 border-neutral-300 px-10 py-2 text-neutral-600 hover:bg-teal-300 transition-all hover:text-white rounded-lg">
          Prompt
        </button>
      </div>

      <div :if={String.length(@transcribed) > 0} class="flex justify-center">
        <h3>Summerized:</h3>
        <%= @transcribed %>
      </div>
      <div :if={String.length(@summerized_transcription) > 0} class="flex justify-center flex-col">
        <h3>Summary of transcription:</h3>
        <%= @summerized_transcription %>
      </div>
      <div :if={String.length(@summerized_prompt) > 0} class="flex justify-center flex-col">
        <h3>Summary of transcription:</h3>
        <%= @summerized_prompt %>
      </div>

      <div :if={String.length(@error) > 0} class="flex justify-center flex-col">
        <h3>Error:</h3>
        <%= @error %>
      </div>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    form_data = %{
      "prompt_text" => "hola",
      "file_name" => ""
    }

    voice_message_folder = "/static/uploads/voice_message"
    folder = Path.join(:code.priv_dir(:rocketchat), voice_message_folder)

    files = File.ls!(folder)

    socket =
      socket
      |> assign(form: to_form(form_data))
      |> assign(files: files)
      |> assign(transcribed: "")
      |> assign(summerized_transcription: "")
      |> assign(summerized_prompt: "")
      |> assign(error: "")

    {:ok, socket}
  end

  def handle_event("prompt", params, socket) do
    file_name = params["file_name"]
    prompt_text = params["prompt_text"]

    transcribed =
      OpenaiService.new()
      |> OpenaiService.transcribe!(file_name)

    summerized_transcription =
      OpenaiService.new()
      |> OpenaiService.summerize!(transcribed)

    summerized_prompt =
      OpenaiService.new()
      |> OpenaiService.summerize!(prompt_text)

    socket =
      socket
      |> update(:transcribed, fn _ -> transcribed end)
      |> update(:summerized_transcription, fn _ -> summerized_transcription end)
      |> update(:summerized_prompt, fn _ -> summerized_prompt end)

    {:noreply, socket}
  end
end
