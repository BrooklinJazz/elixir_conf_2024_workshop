defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view
  use ChatNative, :live_view

  def mount(_params, _session, socket) do
    lorem_ipsum = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sed ante interdum, pellentesque dolor at, rhoncus sapien. Praesent sed augue ex. Donec dignissim at turpis vitae convallis.
    """

    messages = List.duplicate(%{name: "Person 1", content: lorem_ipsum, platform: "web"}, 20)

    {:ok, assign(socket, messages: messages)}
  end
end
