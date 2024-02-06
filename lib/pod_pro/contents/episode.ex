defmodule PodPro.Contents.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "episodes" do
    field :type, :string
    field :description, :string
    field :title, :string
    field :url, :string
    field :pub_date, :naive_datetime
    field :duration, :integer
    belongs_to :podcast, PodPro.Contents.Podcast

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:title, :description, :pub_date, :url, :type, :duration, :podcast_id])
    |> validate_required([:title, :description, :pub_date, :url, :type, :duration, :podcast_id])
  end
end
