defmodule RocketchatWeb.Services.OpenaiService do

  @type credentials_type() :: {:org_id, String.t, :project_id, String.t, :secret_key, String.t}

  @spec new() :: {:ok, credentials_type()}
  def new() do
    org_id = Application.fetch_env!(:rocketchat, :openai_org_id)
    project_id = Application.fetch_env!(:rocketchat, :openai_project_id)
    secret_key = Application.fetch_env!(:rocketchat, :openai_secret_id)

    {:ok, {org_id, project_id, secret_key}}
  end

  def transcribe_stream(credentials, file_name) do
    {_, {org_id, project_id, secret_key}} = credentials

    voice_message_folder = "/static/uploads/voice_message" 

    folder = Path.join(:code.priv_dir(:rocketchat), voice_message_folder)

    file_path = Path.join(folder, file_name)

    file_contents = File.read!(file_path)

    file_name = if (! String.ends_with?(file_name, ".mp3")) do
      file_name <> ".mp3"
    else
      file_name
    end

    model = "whisper-1"

    multipart =
      Multipart.new()
      |> Multipart.add_part(Multipart.Part.text_field(model, "model"))
      |> Multipart.add_part(Multipart.Part.text_field("true", "stream"))
      |> Multipart.add_part(Multipart.Part.text_field("response_format", "text"))
      |> Multipart.add_part(
        Multipart.Part.file_content_field(file_name, file_contents, :file, filename: file_name)
      )

    url = "https://api.openai.com/v1/audio/transcriptions"

    content_length = Multipart.content_length(multipart)
    content_type = Multipart.content_type(multipart, "multipart/form-data")

    headers = %{
      "Authorization" => "Bearer #{secret_key}",
      "OpenAI-Organization" => org_id,
      "OpenAI-Project" => project_id,
      "Content-Type" => content_type,
      "Content-Length" => to_string(content_length)
    }

    resp = 
      Req.post!(url, 
        headers: headers, 
        body: Multipart.body_stream(multipart),
        into: fn {:data, data}, context -> 
          IO.inspect(data) 
          {:cont, context}
        end
      )

    IO.inspect(resp)

    {:ok}
  end
  
  def transcribe!(credentials, file_name) do
    {:ok, r} = transcribe(credentials, file_name)

    r
  end

  def transcribe(credentials, file_name) do
    {_, {org_id, project_id, secret_key}} = credentials

    voice_message_folder = "/static/uploads/voice_message" 

    folder = Path.join(:code.priv_dir(:rocketchat), voice_message_folder)

    file_path = Path.join(folder, file_name)

    file_contents = File.read!(file_path)

    file_name = if (! String.ends_with?(file_name, ".mp3")) do
      file_name <> ".mp3"
    else
      file_name
    end

    model = "whisper-1"

    multipart =
      Multipart.new()
      |> Multipart.add_part(Multipart.Part.text_field(model, "model"))
      |> Multipart.add_part(Multipart.Part.text_field("response_format", "text"))
      |> Multipart.add_part(
        Multipart.Part.file_content_field(file_name, file_contents, :file, filename: file_name)
      )

    url = "https://api.openai.com/v1/audio/transcriptions"

    content_length = Multipart.content_length(multipart)
    content_type = Multipart.content_type(multipart, "multipart/form-data")

    headers = %{
      "Authorization" => "Bearer #{secret_key}",
      "OpenAI-Organization" => org_id,
      "OpenAI-Project" => project_id,
      "Content-Type" => content_type,
      "Content-Length" => to_string(content_length)
    }

    resp = 
      Req.post!(url, 
        headers: headers, 
        body: Multipart.body_stream(multipart)
      )

    IO.inspect(resp)

    {:ok, resp.body["text"]}
  end

  def summerize!(credentials, text) do
    {:ok, r} = summerize(credentials, text)

    r
  end

  def summerize(credentials, text) do
    {_, {org_id, project_id, secret_key}} = credentials

    headers = %{
      "Authorization" => "Bearer #{secret_key}",
      "OpenAI-Organization" => org_id,
      "OpenAI-Project" => project_id,
      "Content-Type" => "application/json",
    }

    url = "https://api.openai.com/v1/chat/completions"
    model = "gpt-3.5-turbo-0125"

    resp = 
      Req.post!(url, 
        headers: headers, 
        json: %{
          "model" => model,
          "response_format" => %{
            "type" => "json_object"
          },
          "messages" => [
            %{
              "role" => "system",
              "content" => "You are a helpful assistant designed to output JSON."
            },
            %{
              "role" => "user",
              "content" => "Summerize the sentence I'm about to send you."
            },
            %{
              "role" => "user",
              "content" => text
            }
          ]
        }
      )

    IO.inspect(resp)

    choices = resp.body["choices"]
    choice = choices |> Enum.at(0)

    content_raw = choice["message"]["content"]

    content = Jason.decode!(content_raw)

    IO.inspect(content)

    {:ok, content["summary"]}
  end
end
