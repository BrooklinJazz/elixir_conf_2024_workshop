defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view
  use ChatNative, :live_view

  def mount(params, _session, socket) do
    if connected?(socket) do
      ChatWeb.Endpoint.subscribe("messages")
    end

    socket =
      socket
      |> assign(:form, to_form(%{}, as: "chat-form"))
      |> assign(:messages, [])

    {:ok, socket}
  end

  def handle_event(
        "send-message",
        %{"chat-form" => %{"content" => content, "name" => name}},
        socket
      ) do

    message = %{content: content, name: name}

    socket =
      socket
      |> assign(:messages, [message | socket.assigns.messages])
      |> assign(:form, to_form(%{"name" => name, "content" => ""}, as: "chat-form"))

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
      <p><%= message.name %></p>
      <p class="mb-2"><%= message.content %></p>
    <% end %>
    </section>
     <.simple_form for={@form} id="form" phx-submit="send-message">
      <.input field={@form[:name]} placeholder="From..." />
      <.input field={@form[:content]} type="textarea" placeholder="Say..." />
      <:actions>
        <.button type="submit">
          Send Message
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end
