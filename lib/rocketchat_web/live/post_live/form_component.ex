defmodule RocketchatWeb.PostLive.FormComponent do
  use RocketchatWeb, :live_component

  alias Rocketchat.Blog

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Blog.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(:image, accept: ~w"image/*")}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Blog.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    _uploaded_files =
      consume_uploaded_entries(socket, :image, fn
        %{path: path}, %Phoenix.LiveView.UploadEntry{client_name: name} ->
          dest_dir = Application.app_dir(:rocketchat, "priv/static/uploads") |> IO.inspect()
          :ok = File.mkdir_p(dest_dir)

          dest =
            Application.app_dir(:rocketchat, "priv/static/uploads")
            |> Path.join(Path.basename(path) <> Path.extname(name))

          File.cp!(path, dest)
          {:ok, dest}
      end)

    case save_post(socket, socket.assigns.action, post_params) do
      {:ok, post, message} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, message)
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :edit, post_params) do
    with {:ok, post} <- Blog.update_post(socket.assigns.post, post_params) do
      {:ok, post, "Post updated successfully"}
    end
  end

  defp save_post(_socket, :new, post_params) do
    with {:ok, post} <- Blog.create_post(post_params) do
      {:ok, post, "Post created successfully"}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage post records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="text" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
        <.image_upload upload={@uploads.image} />
      </.simple_form>
    </div>
    """
  end
end
