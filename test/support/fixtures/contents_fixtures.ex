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

  @doc """
  Generate a episode.
  """
  def episode_fixture(attrs \\ %{}) do
    {:ok, episode} =
      attrs
      |> Enum.into(%{
        description: "some description",
        duration: 42,
        pub_date: ~N[2024-02-04 03:23:00],
        title: "some title",
        type: "some type",
        url: "some url"
      })
      |> PodPro.Contents.create_episode()

    episode
  end
end
