defmodule RocketchatWeb.TestLive do
  alias Rocketchat.Posts
  alias Rocketchat.Posts.Post
  use RocketchatWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(new_post: Posts.change_post(%Post{}))
     # theres an issue with inserts cause reposts have an id of an original post but whatever
     |> stream(:posts, Posts.list_posts(), limit: 100)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("post", %{"post" => post}, socket) do
    user = get_user(socket)
    quoted_post_id = socket.assigns[:quote]

    {:ok, post} =
      %{
        content: post["content"],
        audio_key: "_",
        user: user,
        quoted_post: quoted_post_id && %Posts.Post{id: quoted_post_id}
      }
      |> Posts.create_post()

    post = post |> Map.from_struct() |> Map.merge(%{user: user, reposted_by: nil})

    {:noreply,
     socket
     |> stream_insert(:posts, post, at: 0)
     |> assign(:quote, nil)}
  end

  def handle_event("quote", %{"id" => id}, socket) do
    {:noreply, socket |> assign(:quote, id)}
  end

  def handle_event("repost", %{"id" => id}, socket) do
    {:ok, %Posts.Repost{post: post, user: user}} =
      %{user: get_user(socket), post: %Posts.Post{id: id}}
      |> Posts.create_repost()

    post =
      post
      |> Map.from_struct()
      |> Map.merge(%{reposted_by: user.email, quoted_post: nil})

    {:noreply, socket |> stream_insert(:posts, post, at: 0)}
  end

  def handle_event("delete", %{"id" => id, "reposted_by" => reposted_by}, socket) do
    post =
      if reposted_by do
        user = get_user(socket)

        {:ok, _} =
          %Posts.Repost{author_id: user.id, post_id: id}
          |> Posts.delete_repost()

        %{id: id, reposted_by: reposted_by}
      else
        post = %Post{id: id}
        {:ok, _} = post |> Posts.delete_post()
        post
      end

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
      <div :if={@post.reposted_by}><b>Reposted by: </b><%= @post.reposted_by %></div>
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
          class="font-bold p-1 rounded-lg bg-neutral-200"
          phx-click={JS.push("delete", value: %{id: @post.id, reposted_by: @post.reposted_by})}
        >
          delete
        </button>
        <button
          class="font-bold p-1 rounded-lg bg-neutral-200"
          phx-click={JS.push("repost", value: %{id: @post.id})}
        >
          repost
        </button>
        <button
          class="font-bold p-1 rounded-lg bg-neutral-200"
          phx-click={JS.push("quote", value: %{id: @post.id})}
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
end
