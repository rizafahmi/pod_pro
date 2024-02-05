defmodule PodProWeb.PodcastLive.FormComponent do
  use PodProWeb, :live_component

  alias PodPro.Contents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage podcast records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="podcast-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:author]} type="text" label="Author" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:category]} type="text" label="Category" />
        <.input field={@form[:thumbnail]} type="text" label="Thumbnail" />
        <.input field={@form[:language]} type="text" label="Language" />
        <.input field={@form[:link]} type="text" label="Link" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Podcast</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{podcast: podcast} = assigns, socket) do
    changeset = Contents.change_podcast(podcast)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"podcast" => podcast_params}, socket) do
    changeset =
      socket.assigns.podcast
      |> Contents.change_podcast(podcast_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"podcast" => podcast_params}, socket) do
    save_podcast(socket, socket.assigns.action, podcast_params)
  end

  defp save_podcast(socket, :edit, podcast_params) do
    case Contents.update_podcast(socket.assigns.podcast, podcast_params) do
      {:ok, podcast} ->
        notify_parent({:saved, podcast})

        {:noreply,
         socket
         |> put_flash(:info, "Podcast updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_podcast(socket, :new, podcast_params) do
    case Contents.create_podcast(podcast_params) do
      {:ok, podcast} ->
        notify_parent({:saved, podcast})

        {:noreply,
         socket
         |> put_flash(:info, "Podcast created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
