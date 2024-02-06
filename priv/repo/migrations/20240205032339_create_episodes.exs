defmodule PodPro.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :pub_date, :naive_datetime
      add :url, :string
      add :type, :string
      add :duration, :integer
      add :podcast_id, references(:podcasts, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:episodes, [:podcast_id])
  end
end
