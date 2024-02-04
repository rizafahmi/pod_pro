defmodule PodProWeb.PodcastLiveTest do
  use PodProWeb.ConnCase

  import Phoenix.LiveViewTest
  import PodPro.ContentsFixtures

  @create_attrs %{link: "some link", description: "some description", title: "some title", author: "some author", category: "some category", url: "some url", language: "some language", thumbnail: "some thumbnail"}
  @update_attrs %{link: "some updated link", description: "some updated description", title: "some updated title", author: "some updated author", category: "some updated category", url: "some updated url", language: "some updated language", thumbnail: "some updated thumbnail"}
  @invalid_attrs %{link: nil, description: nil, title: nil, author: nil, category: nil, url: nil, language: nil, thumbnail: nil}

  defp create_podcast(_) do
    podcast = podcast_fixture()
    %{podcast: podcast}
  end

  describe "Index" do
    setup [:create_podcast]

    test "lists all podcasts", %{conn: conn, podcast: podcast} do
      {:ok, _index_live, html} = live(conn, ~p"/podcasts")

      assert html =~ "Listing Podcasts"
      assert html =~ podcast.link
    end

    test "saves new podcast", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/podcasts")

      assert index_live |> element("a", "New Podcast") |> render_click() =~
               "New Podcast"

      assert_patch(index_live, ~p"/podcasts/new")

      assert index_live
             |> form("#podcast-form", podcast: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#podcast-form", podcast: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/podcasts")

      html = render(index_live)
      assert html =~ "Podcast created successfully"
      assert html =~ "some link"
    end

    test "updates podcast in listing", %{conn: conn, podcast: podcast} do
      {:ok, index_live, _html} = live(conn, ~p"/podcasts")

      assert index_live |> element("#podcasts-#{podcast.id} a", "Edit") |> render_click() =~
               "Edit Podcast"

      assert_patch(index_live, ~p"/podcasts/#{podcast}/edit")

      assert index_live
             |> form("#podcast-form", podcast: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#podcast-form", podcast: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/podcasts")

      html = render(index_live)
      assert html =~ "Podcast updated successfully"
      assert html =~ "some updated link"
    end

    test "deletes podcast in listing", %{conn: conn, podcast: podcast} do
      {:ok, index_live, _html} = live(conn, ~p"/podcasts")

      assert index_live |> element("#podcasts-#{podcast.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#podcasts-#{podcast.id}")
    end
  end

  describe "Show" do
    setup [:create_podcast]

    test "displays podcast", %{conn: conn, podcast: podcast} do
      {:ok, _show_live, html} = live(conn, ~p"/podcasts/#{podcast}")

      assert html =~ "Show Podcast"
      assert html =~ podcast.link
    end

    test "updates podcast within modal", %{conn: conn, podcast: podcast} do
      {:ok, show_live, _html} = live(conn, ~p"/podcasts/#{podcast}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Podcast"

      assert_patch(show_live, ~p"/podcasts/#{podcast}/show/edit")

      assert show_live
             |> form("#podcast-form", podcast: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#podcast-form", podcast: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/podcasts/#{podcast}")

      html = render(show_live)
      assert html =~ "Podcast updated successfully"
      assert html =~ "some updated link"
    end
  end
end
