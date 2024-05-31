defmodule RocketchatWeb.TestLive do
  alias Rocketchat.Posts
  alias Rocketchat.Posts.Post
  use RocketchatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(new_post: Posts.change_post(%Post{}))
     |> stream(:posts, Posts.list_posts(), limit: 100)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("post", %{"post" => post}, socket) do
    user = socket.assigns.current_user
    quoted_id = socket.assigns[:quote]

    {:ok, post} =
      %{
        content: post["content"],
        audio_key: "_",
        user: user,
        # todo - finish quotes
        quoted_post: if(quoted_id, do: %Posts.Post{id: quoted_id})
      }
      |> Posts.create_post()

    {:noreply,
     socket
     |> stream_insert(:posts, %Posts.Post{post | user: user}, at: 0)}
  end

  def handle_event("quote", %{"id" => id}, socket) do
    {:noreply, socket |> assign(:quote, id)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = %Post{id: id}
    {:ok, _} = Posts.delete_post(post)
    {:noreply, socket |> stream_delete(:posts, post)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex flex-col gap-2" phx-update="stream" id="feed">
        <%= for {id, post} <- @streams.posts do %>
          <.post_card id={id} post={post} />
        <% end %>
      </div>
      <.new_post form={@new_post} />
    </div>
    """
  end

  defp post_card(assigns) do
    ~H"""
    <div id={@id} class="bg-neutral-400 rounded-lg p-2">
      <div><b>by: </b><%= @post.user.email %></div>
      <div><%= @post.content %></div>
      <%= if @post.quoted_post do %>
        <div class="bg-neutral-300 rounded-lg p-1">
          <b>Quote by: </b><%= @post.quoted_post.user.email %>
          <div>
            <%= @post.quoted_post.content %>
          </div>
        </div>
      <% end %>
      <button
        class="font-bold p-1 rounded-lg bg-neutral-200"
        phx-click={JS.push("delete", value: %{id: @post.id})}
      >
        delete
      </button>
      <button
        class="font-bold p-1 rounded-lg bg-neutral-200"
        phx-click={JS.push("quote", value: %{id: @post.id})}
      >
        quote
      </button>
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
end
