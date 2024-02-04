defmodule PodPro.ContentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PodPro.Contents` context.
  """

  @doc """
  Generate a podcast.
  """
  def podcast_fixture(attrs \\ %{}) do
    {:ok, podcast} =
      attrs
      |> Enum.into(%{
        author: "some author",
        category: "some category",
        description: "some description",
        language: "some language",
        link: "some link",
        thumbnail: "some thumbnail",
        title: "some title",
        url: "some url"
      })
      |> PodPro.Contents.create_podcast()

    podcast
  end
end
