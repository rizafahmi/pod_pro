defmodule PodProWeb.EpisodeLive.Show do
  use PodProWeb, :live_view

  alias PodPro.Contents

  @impl true
  def mount(params, _session, socket) do
    socket = socket |> assign(:podcast_id, params["pod_id"])
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"pod_id" => podcast_id, "id" => id}, _, socket) do
    episode = Contents.get_episode!(id)

    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:episode, episode)
      |> assign(:podcast_id, podcast_id)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Episode"
  defp page_title(:edit), do: "Edit Episode"
end
