defmodule PodPro.ContentsTest do
  use PodPro.DataCase

  alias PodPro.Contents

  describe "podcasts" do
    alias PodPro.Contents.Podcast

    import PodPro.ContentsFixtures

    @invalid_attrs %{link: nil, description: nil, title: nil, author: nil, category: nil, url: nil, language: nil, thumbnail: nil}

    test "list_podcasts/0 returns all podcasts" do
      podcast = podcast_fixture()
      assert Contents.list_podcasts() == [podcast]
    end

    test "get_podcast!/1 returns the podcast with given id" do
      podcast = podcast_fixture()
      assert Contents.get_podcast!(podcast.id) == podcast
    end

    test "create_podcast/1 with valid data creates a podcast" do
      valid_attrs = %{link: "some link", description: "some description", title: "some title", author: "some author", category: "some category", url: "some url", language: "some language", thumbnail: "some thumbnail"}

      assert {:ok, %Podcast{} = podcast} = Contents.create_podcast(valid_attrs)
      assert podcast.link == "some link"
      assert podcast.description == "some description"
      assert podcast.title == "some title"
      assert podcast.author == "some author"
      assert podcast.category == "some category"
      assert podcast.url == "some url"
      assert podcast.language == "some language"
      assert podcast.thumbnail == "some thumbnail"
    end

    test "create_podcast/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_podcast(@invalid_attrs)
    end

    test "update_podcast/2 with valid data updates the podcast" do
      podcast = podcast_fixture()
      update_attrs = %{link: "some updated link", description: "some updated description", title: "some updated title", author: "some updated author", category: "some updated category", url: "some updated url", language: "some updated language", thumbnail: "some updated thumbnail"}

      assert {:ok, %Podcast{} = podcast} = Contents.update_podcast(podcast, update_attrs)
      assert podcast.link == "some updated link"
      assert podcast.description == "some updated description"
      assert podcast.title == "some updated title"
      assert podcast.author == "some updated author"
      assert podcast.category == "some updated category"
      assert podcast.url == "some updated url"
      assert podcast.language == "some updated language"
      assert podcast.thumbnail == "some updated thumbnail"
    end

    test "update_podcast/2 with invalid data returns error changeset" do
      podcast = podcast_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_podcast(podcast, @invalid_attrs)
      assert podcast == Contents.get_podcast!(podcast.id)
    end

    test "delete_podcast/1 deletes the podcast" do
      podcast = podcast_fixture()
      assert {:ok, %Podcast{}} = Contents.delete_podcast(podcast)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_podcast!(podcast.id) end
    end

    test "change_podcast/1 returns a podcast changeset" do
      podcast = podcast_fixture()
      assert %Ecto.Changeset{} = Contents.change_podcast(podcast)
    end
  end

  describe "episodes" do
    alias PodPro.Contents.Episode

    import PodPro.ContentsFixtures

    @invalid_attrs %{type: nil, description: nil, title: nil, url: nil, pub_date: nil, duration: nil}

    test "list_episodes/0 returns all episodes" do
      episode = episode_fixture()
      assert Contents.list_episodes() == [episode]
    end

    test "get_episode!/1 returns the episode with given id" do
      episode = episode_fixture()
      assert Contents.get_episode!(episode.id) == episode
    end

    test "create_episode/1 with valid data creates a episode" do
      valid_attrs = %{type: "some type", description: "some description", title: "some title", url: "some url", pub_date: ~N[2024-02-04 03:23:00], duration: 42}

      assert {:ok, %Episode{} = episode} = Contents.create_episode(valid_attrs)
      assert episode.type == "some type"
      assert episode.description == "some description"
      assert episode.title == "some title"
      assert episode.url == "some url"
      assert episode.pub_date == ~N[2024-02-04 03:23:00]
      assert episode.duration == 42
    end

    test "create_episode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_episode(@invalid_attrs)
    end

    test "update_episode/2 with valid data updates the episode" do
      episode = episode_fixture()
      update_attrs = %{type: "some updated type", description: "some updated description", title: "some updated title", url: "some updated url", pub_date: ~N[2024-02-05 03:23:00], duration: 43}

      assert {:ok, %Episode{} = episode} = Contents.update_episode(episode, update_attrs)
      assert episode.type == "some updated type"
      assert episode.description == "some updated description"
      assert episode.title == "some updated title"
      assert episode.url == "some updated url"
      assert episode.pub_date == ~N[2024-02-05 03:23:00]
      assert episode.duration == 43
    end

    test "update_episode/2 with invalid data returns error changeset" do
      episode = episode_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_episode(episode, @invalid_attrs)
      assert episode == Contents.get_episode!(episode.id)
    end

    test "delete_episode/1 deletes the episode" do
      episode = episode_fixture()
      assert {:ok, %Episode{}} = Contents.delete_episode(episode)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_episode!(episode.id) end
    end

    test "change_episode/1 returns a episode changeset" do
      episode = episode_fixture()
      assert %Ecto.Changeset{} = Contents.change_episode(episode)
    end
  end
end
