defmodule RocketchatWeb.FeedComponents do
  use Phoenix.Component
  import RocketchatWeb.Icons

  attr :tab, :string, required: true

  def top_header(assigns) do
    IO.inspect(assigns.tab)

    ~H"""
    <div class="flex flex-col gap-5 pt-5 bg-white sticky top-0 z-10">
      <div class="flex justify-between items-center px-8">
        <button>
          <div class="relative flex justify-center items-center">
            <.person_icon />
          </div>
        </button>
        <div class="font-spacemonkey">Rocketchat</div>
        <div></div>
      </div>
      <!-- Feed Tabs -->
      <div class="flex justify-center gap-10 px-20">
        <.tab_button active?={@tab == :fyp} tab="fyp">
          For You
        </.tab_button>
        <.tab_button active?={@tab == :following} tab="following">
          Following
        </.tab_button>
      </div>
    </div>
    """
  end

  attr :tab, :string, required: true
  attr :active?, :boolean, required: true

  slot :inner_block, required: true

  defp tab_button(assigns) do
    ~H"""
    <button
      phx-click="switch_tabs"
      phx-value-tab={@tab}
      class={if @active?, do: "border-b-2 border-cyan-500 font-semibold whitespace-nowrap"}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  def new_message_box(assigns) do
    ~H"""
    <div class="flex px-3 gap-3 items-center pt-5 pb-2">
      <div class="relative rounded-full min-h-[2.5rem] max-h-[2.5rem] min-w-[2.5rem] max-w-[2.5rem]">
        <img class="absolute w-full h-full rounded-full border-2" />
      </div>

      <div class="rounded-2xl shadow-2xl bg-white px-4 py-5 flex flex-col w-full">
        <h3>John</h3>
        <input
          placeholder="New post to followers..."
          class="placeholder:text-slate-400 focus:outline-none"
        />
      </div>
    </div>
    """
  end

  def bottom_navbar(assigns) do
    ~H"""
    <div class="w-full sticky bottom-0 flex items-center justify-between px-8 bg-white shadow-xl">
      <button>
        <div class="relative h-6 w-6">
          <.home_icon />
        </div>
      </button>
      <button class="">
        <div class="relative h-6 w-6">
          <.search_icon />
        </div>
      </button>
      <button class="rounded-full border-8 border-white bg-black p-4 relative -top-3">
        <div class="h-6 w-6 shadow-xl relative">
          <img src="https://i.imgur.com/RAw6gOc.png" class="absolute" />
        </div>
      </button>
      <button>
        <div class="relative h-6 w-6">
          <.notification_icon />
        </div>
      </button>
      <button>
        <div class="relative h-6 w-6">
          <.direct_message_icon />
        </div>
      </button>
    </div>
    """
  end

  attr :author_name, :string, required: true

  def chat_item(assigns) do
    ~H"""
    <!-- A Single Chat Item -->
    <div class="flex px-3 py-5 gap-3 bg-[#f7f8fa] border-y-[#efefef] border-y">
      <!-- Profile Picture Area -->
      <div class="flex flex-col relative items-end">
        <div class="relative rounded-full min-h-[2.5rem] max-h-[2.5rem] min-w-[2.5rem] max-w-[2.5rem]">
          <img class="absolute w-full h-full rounded-full border-2" />
        </div>
        <button class="relative bottom-3 -right-1 rounded-full bg-sky-500 h-5 w-5 text-[0.7rem] text-white font-bold leading-none align-middle flex items-center justify-center border border-white">
          +
        </button>
      </div>
      <!-- Message Content Area -->
      <div class="mt-1 flex flex-col w-full">
        <div class="rounded-2xl shadow-lg bg-white px-4 py-3 flex flex-col w-full">
          <div class="flex gap-2 items-end">
            <h3 class="font-bold"><%= @author_name %></h3>
            <span class="text-slate-500 text-sm">3w</span>
          </div>

          <div class="leading-5 text-sm">
            Hey everyone! Welcome to the channel. As the name suggests,
            this channel has been created with the sole intention of
            sharing our stories, our struggles, our victories, our highs or
            our lows. Here we will not only offer support or i...
          </div>
        </div>
        <!-- Action controls -->
        <div class="relative flex justify-end">
          <div class="relative bottom-3 border-1 border-slate-200 rounded-full shadow-lg bg-white py-0.5 px-5 text-sm flex gap-3">
            <!-- Like -->
            <div class="flex gap-2 items-center">
              <button>
                <div class="relative">
                  <.heart_icon />
                </div>
              </button>
              <span>100</span>
            </div>
            <!-- Repost -->
            <div class="flex gap-2 items-center">
              <button>
                <div class="relative">
                  <.repost_icon />
                </div>
              </button>
              <span>100</span>
            </div>
            <!-- Share -->
            <div class="flex gap-2 items-center">
              <button>
                <div class="relative">
                  <.share_icon />
                </div>
              </button>
            </div>
          </div>
        </div>
        <!-- Replies -->
        <div class="flex gap-2">
          <div class="relative rounded-full min-h-[1.5rem] max-h-[1.5rem] min-w-[1.5rem] max-w-[1.5rem]">
            <img class="absolute w-full h-full rounded-full border-2" />
          </div>
          <div class="relative rounded-full min-h-[1.5rem] max-h-[1.5rem] min-w-[1.5rem] max-w-[1.5rem]">
            <img class="absolute w-full h-full rounded-full border-2" />
          </div>
          <div class="relative rounded-full min-h-[1.5rem] max-h-[1.5rem] min-w-[1.5rem] max-w-[1.5rem]">
            <img class="absolute w-full h-full rounded-full border-2" />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
