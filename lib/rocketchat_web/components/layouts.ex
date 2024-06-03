defmodule RocketchatWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use RocketchatWeb, :controller` and
  `use RocketchatWeb, :live_view`.
  """
  use RocketchatWeb, :html

  def app(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8">
      <nav class="flex gap-2">
        <.pretty_link patch={~p"/"}>home</.pretty_link>
        <.pretty_link patch={~p"/feed"}>feed</.pretty_link>
        <.pretty_link patch={~p"/feed_test"}>feed test</.pretty_link>
        <.pretty_link patch={~p"/speech_test"}>speech test</.pretty_link>
      </nav>
    </header>
    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl">
        <.flash_group flash={@flash} />
        <%= @inner_content %>
      </div>
    </main>
    """
  end

  defp pretty_link(assigns) do
    ~H"""
    <.link patch={@patch} class="hover:underline">
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def root(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="[scrollbar-gutter:stable]">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <.live_title suffix={assigns[:page_title] && " · Rocketchat"}>
          <%= assigns[:page_title] || "Rocketchat" %>
        </.live_title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
      </head>
      <body class="bg-white antialiased">
        <%= @inner_content %>
      </body>
    </html>
    """
  end
end
