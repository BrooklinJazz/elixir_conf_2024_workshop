defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view
  use ChatNative, :live_view

  def mount(params, _session, socket) do
    if connected?(socket) do
      ChatWeb.Endpoint.subscribe("messages")
    end

    lorem_ipsum = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sed ante interdum, pellentesque dolor at, rhoncus sapien. Praesent sed augue ex. Donec dignissim at turpis vitae convallis.
    """

    os = socket.assigns["_interface"]["os"] || "web"

    # messages =
    #   List.duplicate(%{content: lorem_ipsum, name: "Person 1", os: "web"}, 20)

    socket =
      socket
      |> assign(:form, to_form(%{"name" => "Brook"}, as: "chat-form"))
      |> assign(:messages, [])
      |> assign(:os, os)

    {:ok, socket}
  end

  def handle_event(
        "send-message",
        %{"chat-form" => %{"content" => content, "name" => name}},
        socket
      ) do

    message = %{content: content, name: name, os: socket.assigns.os}

    socket =
      socket
      |> assign(:messages, [message | socket.assigns.messages])
      |> assign(:form, to_form(%{"name" => name}, as: "chat-form"))

      ChatWeb.Endpoint.broadcast_from(self(), "messages", "send-message", message)

    {:noreply, socket}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "messages", event: "send-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message | socket.assigns.messages])}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl">Chat App</h1>
    <section class="h-[400px] overflow-y-scroll">
    <%= for message <- @messages do %>
      <p><%= message.name %> (<%= message.os %>)</p>
      <p class="mb-2"><%= message.content %></p>
    <% end %>
    </section>
     <.simple_form for={@form} id="form" phx-submit="send-message">
      <.input field={@form[:name]} placeholder="From..." />
      <.input field={@form[:content]} placeholder="Say..." />
      <:actions>
        <.button type="submit">
          Send Message
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end
