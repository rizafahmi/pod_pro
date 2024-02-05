defmodule PodPro.Contents.Podcast do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "podcasts" do
    field :link, :string
    field :description, :string
    field :title, :string
    field :author, :string
    field :category, :string
    field :url, :string
    field :language, :string
    field :thumbnail, :string
    field :slug, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(podcast, attrs) do
    podcast
    |> cast(attrs, [
      :url,
      :title,
      :author,
      :description,
      :category,
      :thumbnail,
      :language,
      :link,
      :slug
    ])
    |> validate_required([
      :url,
      :title,
      :author,
      :description,
      :language,
      :link,
      :slug
    ])
  end
end
