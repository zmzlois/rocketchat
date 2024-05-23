defmodule RocketchatWeb.PostLive.Show do
  use RocketchatWeb, :live_view

  alias Rocketchat.Blog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Blog.get_post!(id))}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Post <%= @post.id %>
      <:subtitle>This is a post record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/posts/#{@post}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit post</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Title"><%= @post.title %></:item>
      <:item title="Body"><%= @post.body %></:item>
    </.list>

    <.back navigate={~p"/posts"}>Back to posts</.back>

    <.modal :if={@live_action == :edit} id="post-modal" show on_cancel={JS.patch(~p"/posts/#{@post}")}>
      <.live_component
        module={RocketchatWeb.PostLive.FormComponent}
        id={@post.id}
        title={@page_title}
        action={@live_action}
        post={@post}
        patch={~p"/posts/#{@post}"}
      />
    </.modal>
    """
  end
end
