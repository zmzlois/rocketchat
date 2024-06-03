defmodule RocketchatWeb.Services.OpenaiService do
  def transcribe(file) do
    multipart =
      Multipart.new()
      |> Multipart.add_part(Multipart.Part.text_field("whisper-1", "model"))
      |> Multipart.add_part(Multipart.Part.text_field("text", "response_format"))
      |> Multipart.add_part(Multipart.Part.file_content_field(".webm", file, "file"))

    content_type = Multipart.content_type(multipart, "multipart/form-data")
    headers = %{"Content-Type" => content_type} |> get_headers()
    url = "https://api.openai.com/v1/audio/transcriptions"

    resp_opt =
      Req.post(url,
        headers: headers,
        body: Multipart.body_stream(multipart)
      )

    with {:ok, resp} <- resp_opt do
      {:ok, resp.body}
    end
  end

  def transcribe!(file) do
    file |> transcribe() |> assert_ok()
  end

  def summarize(text) do
    headers = %{"Content-Type" => "application/json"} |> get_headers()
    url = "https://api.openai.com/v1/chat/completions"

    resp_opt =
      Req.post(url,
        headers: headers,
        json: %{
          "model" => "gpt-3.5-turbo-0125",
          "response_format" => %{"type" => "json_object"},
          "messages" => [
            %{
              "role" => "system",
              "content" => "You are a helpful assistant designed to output JSON."
            },
            %{
              "role" => "user",
              "content" =>
                "Response with a brief summary of the next message. If you are unable to provide summary - repond with 'null'"
            },
            %{
              "role" => "user",
              "content" => text
            }
          ]
        }
      )

    with {:ok, resp} <- resp_opt,
         choice = resp.body["choices"] |> List.first(),
         content_raw = choice["message"]["content"],
         {:ok, content} <- Jason.decode(content_raw) do
      summary =
        with "null" <- content["summary"] do
          nil
        end

      {:ok, summary}
    end
  end

  def summarize!(text) do
    text |> summarize() |> assert_ok()
  end

  defp assert_ok(data) do
    {:ok, data} = data
    data
  end

  defp get_headers(headers) do
    {:ok, {org_id, project_id, secret_key}} = get_credentials()

    %{
      "Authorization" => "Bearer #{secret_key}",
      "OpenAI-Organization" => org_id,
      "OpenAI-Project" => project_id
    }
    |> Map.merge(headers)
  end

  @type credentials_type() ::
          {:org_id, String.t(), :project_id, String.t(), :secret_key, String.t()}

  @spec get_credentials() :: {credentials_type()}
  defp get_credentials() do
    with {:ok, org_id} <- Application.fetch_env(:rocketchat, :openai_org_id),
         {:ok, project_id} <- Application.fetch_env(:rocketchat, :openai_project_id),
         {:ok, secret_key} <- Application.fetch_env(:rocketchat, :openai_secret_id) do
      {:ok, {org_id, project_id, secret_key}}
    end
  end
end
