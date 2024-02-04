defmodule PodPro.Repo.Migrations.CreatePodcasts do
  use Ecto.Migration

  def change do
    create table(:podcasts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :title, :string
      add :author, :string
      add :description, :text
      add :category, :string
      add :thumbnail, :string
      add :language, :string
      add :link, :string

      timestamps(type: :utc_datetime)
    end
  end
end
