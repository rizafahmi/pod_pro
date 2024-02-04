defmodule PodProWeb.PodcastLive.Index do
  use PodProWeb, :live_view

  alias PodPro.Contents
  alias PodPro.Contents.Podcast

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :podcasts, Contents.list_podcasts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Podcast")
    |> assign(:podcast, Contents.get_podcast!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Podcast")
    |> assign(:podcast, %Podcast{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Podcasts")
    |> assign(:podcast, nil)
  end

  @impl true
  def handle_info({PodProWeb.PodcastLive.FormComponent, {:saved, podcast}}, socket) do
    {:noreply, stream_insert(socket, :podcasts, podcast)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    podcast = Contents.get_podcast!(id)
    {:ok, _} = Contents.delete_podcast(podcast)

    {:noreply, stream_delete(socket, :podcasts, podcast)}
  end
end
