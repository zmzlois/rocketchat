defmodule RocketchatWeb.PostLive.Index do
  use RocketchatWeb, :live_view

  alias Rocketchat.Blog
  alias Rocketchat.Blog.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :posts, Blog.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Blog.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({RocketchatWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)
    {:ok, _} = Blog.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    {:noreply, stream(socket, :posts, Blog.list_posts(filter), reset: true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Posts
      <:actions>
        <.link patch={~p"/posts/new"}>
          <.button>New Post</.button>
        </.link>
      </:actions>
    </.header>
    <form>
      <input name="filter" placeholder="filter" phx-change={JS.push("filter")} />
    </form>
    <.table
      id="posts"
      rows={@streams.posts}
      row_click={fn {_id, post} -> JS.navigate(~p"/posts/#{post}") end}
    >
      <:col :let={{_id, post}} label="Title"><%= post.title %></:col>
      <:col :let={{_id, post}} label="Body"><%= post.body %></:col>
      <:action :let={{_id, post}}>
        <div class="sr-only">
          <.link navigate={~p"/posts/#{post}"}>Show</.link>
        </div>
        <.link patch={~p"/posts/#{post}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, post}}>
        <.link phx-click={JS.push("delete", value: %{id: post.id}) |> hide("##{id}")}>
          Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="post-modal" show on_cancel={JS.patch(~p"/posts")}>
      <.live_component
        module={RocketchatWeb.PostLive.FormComponent}
        id={@post.id || :new}
        title={@page_title}
        action={@live_action}
        post={@post}
        patch={~p"/posts"}
      />
    </.modal>
    """
  end
end
