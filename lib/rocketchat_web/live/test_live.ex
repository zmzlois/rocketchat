defmodule RocketchatWeb.TestLive do
  alias Rocketchat.Posts
  alias Rocketchat.Posts.Post
  use RocketchatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(new_post: Posts.change_post(%Post{}), quote: nil)
     |> stream(:posts, Posts.list_feed_posts(), limit: 100)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("post", %{"post" => post}, socket) do
    user = get_user(socket)

    {:ok, post} =
      %{content: post["content"], audio_key: "_"}
      |> Posts.create_post(user, socket.assigns[:quote])

    {:noreply,
     socket
     |> stream_insert(:posts, post, at: 0)
     |> assign(:quote, nil)}
  end

  def handle_event("quote", %{"id" => id}, socket) do
    {:noreply, socket |> assign(:quote, id)}
  end

  def handle_event("repost", %{"id" => id}, socket) do
    {:ok, post} = Posts.create_repost(id, get_user(socket))

    {:noreply,
     socket
     |> stream_insert(:posts, post, at: 0)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, post} = Posts.delete_post(%Posts.Post{id: id})

    {:noreply,
     socket
     |> flush_feed_posts(post)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex flex-col gap-2" phx-update="stream" id="feed">
        <%= for {id, %Posts.FeedPost{post: post , user: author}} <- @streams.posts do %>
          <.post_card id={id} post={post} author={author} />
        <% end %>
      </div>
      <.new_post form={@new_post} />
    </div>
    """
  end

  defp post_card(assigns) do
    ~H"""
    <div id={@id} class="bg-neutral-400 rounded-lg p-2">
      <div :if={@author.id != @post.author_id}><b>Reposted by: </b><%= @author.email %></div>
      <div><b>by: </b><%= @post.user.email %></div>
      <div><%= @post.content %></div>
      <div>on: <%= @post.inserted_at %></div>
      <%= if @post.quoted_post do %>
        <div class="bg-neutral-300 rounded-lg p-1">
          <b>Quote by: </b><%= @post.quoted_post.user.email %>
          <div>
            <%= @post.quoted_post.content %>
          </div>
        </div>
      <% end %>
      <div class="flex gap-2 p-2">
        <button
          phx-click={JS.push("delete", value: %{id: @post.id})}
          class="font-bold p-1 rounded-lg bg-neutral-200"
        >
          delete
        </button>
        <button
          :if={@author.id != @post.author_id}
          phx-click={JS.push("repost", value: %{id: @post.id})}
          class="font-bold p-1 rounded-lg bg-neutral-200"
        >
          repost
        </button>
        <button
          phx-click={JS.push("quote", value: %{id: @post.id})}
          class="font-bold p-1 rounded-lg bg-neutral-200"
        >
          quote
        </button>
      </div>
    </div>
    """
  end

  defp new_post(assigns) do
    ~H"""
    <.form
      :let={form}
      for={@form}
      phx-submit="post"
      class="fixed bottom-0 bg-neutral-300 inset-x-0 p-2 flex justify-center gap-2 items-center"
    >
      <.var :let={field} var={form[:content]}>
        <textarea name={field.name} placeholder="new post"><%= field.value %></textarea>
      </.var>
      <button class="p-3 rounded-lg bg-neutral-200">post</button>
    </.form>
    """
  end

  defp var(assigns) do
    ~H"""
    <%= render_slot(@inner_block, @var) %>
    """
  end

  defp get_user(socket) do
    socket.assigns.current_user
  end

  defp flush_feed_posts(socket = %Phoenix.LiveView.Socket{}, %Posts.Post{feed_posts: posts}) do
    Enum.reduce(posts, socket, fn post, socket ->
      socket |> stream_delete(:posts, post)
    end)
  end
end
