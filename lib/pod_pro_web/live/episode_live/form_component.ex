defmodule PodProWeb.EpisodeLive.FormComponent do
  use PodProWeb, :live_component

  alias PodPro.Contents

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %> for <%= @podcast_id %>
        <:subtitle>Use this form to manage episode records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="episode-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:pub_date]} type="datetime-local" label="Pub date" />
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:type]} type="text" label="Type" />
        <.input field={@form[:duration]} type="number" label="Duration" />
        <.input field={@form[:podcast_id]} value={@podcast_id} type="hidden" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Episode</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{episode: episode} = assigns, socket) do
    changeset = Contents.change_episode(episode)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  def handle_params(params, _url, socket) do
    dbg(params)
    {:ok, assign(socket, params)}
  end

  @impl true
  def handle_event("validate", %{"episode" => episode_params}, socket) do
    dbg(socket.assigns)

    changeset =
      socket.assigns.episode
      |> Contents.change_episode(episode_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"episode" => episode_params}, socket) do
    save_episode(socket, socket.assigns.action, episode_params)
  end

  defp save_episode(socket, :edit, episode_params) do
    case Contents.update_episode(socket.assigns.episode, episode_params) do
      {:ok, episode} ->
        notify_parent({:saved, episode})

        {:noreply,
         socket
         |> put_flash(:info, "Episode updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_episode(socket, :new, episode_params) do
    case Contents.create_episode(episode_params) do
      {:ok, episode} ->
        notify_parent({:saved, episode})

        {:noreply,
         socket
         |> put_flash(:info, "Episode created successfully")
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
