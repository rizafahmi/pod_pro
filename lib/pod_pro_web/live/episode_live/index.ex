defmodule PodProWeb.EpisodeLive.Index do
  use PodProWeb, :live_view

  alias PodPro.Contents
  alias PodPro.Contents.Episode

  @impl true
  def mount(params, _session, socket) do
    socket = socket |> assign(:podcast_id, params["pod_id"])
    {:ok, stream(socket, :episodes, Contents.list_episodes(params["pod_id"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:podcast_id, params["pod_id"])

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Episode")
    |> assign(:episode, Contents.get_episode!(id))
  end

  defp apply_action(socket, :new, %{"pod_id" => podcast_id}) do
    socket
    |> assign(:page_title, "New Episode")
    |> assign(:episode, %Episode{})
    |> assign(:podcast_id, podcast_id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Episodes")
    |> assign(:episode, nil)
  end

  @impl true
  def handle_info({PodProWeb.EpisodeLive.FormComponent, {:saved, episode}}, socket) do
    {:noreply, stream_insert(socket, :episodes, episode)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    episode = Contents.get_episode!(id)
    {:ok, _} = Contents.delete_episode(episode)

    {:noreply, stream_delete(socket, :episodes, episode)}
  end
end
