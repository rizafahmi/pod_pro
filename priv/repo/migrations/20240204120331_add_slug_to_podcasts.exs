defmodule PodPro.Repo.Migrations.AddSlugToPodcasts do
  use Ecto.Migration

  def change do
    alter table(:podcasts) do
      add :slug, :string
    end
  end
end
