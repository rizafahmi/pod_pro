defmodule PodProWeb.EpisodeLiveTest do
  use PodProWeb.ConnCase

  import Phoenix.LiveViewTest
  import PodPro.ContentsFixtures

  @create_attrs %{type: "some type", description: "some description", title: "some title", url: "some url", pub_date: "2024-02-04T03:23:00", duration: 42}
  @update_attrs %{type: "some updated type", description: "some updated description", title: "some updated title", url: "some updated url", pub_date: "2024-02-05T03:23:00", duration: 43}
  @invalid_attrs %{type: nil, description: nil, title: nil, url: nil, pub_date: nil, duration: nil}

  defp create_episode(_) do
    episode = episode_fixture()
    %{episode: episode}
  end

  describe "Index" do
    setup [:create_episode]

    test "lists all episodes", %{conn: conn, episode: episode} do
      {:ok, _index_live, html} = live(conn, ~p"/episodes")

      assert html =~ "Listing Episodes"
      assert html =~ episode.type
    end

    test "saves new episode", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/episodes")

      assert index_live |> element("a", "New Episode") |> render_click() =~
               "New Episode"

      assert_patch(index_live, ~p"/episodes/new")

      assert index_live
             |> form("#episode-form", episode: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#episode-form", episode: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/episodes")

      html = render(index_live)
      assert html =~ "Episode created successfully"
      assert html =~ "some type"
    end

    test "updates episode in listing", %{conn: conn, episode: episode} do
      {:ok, index_live, _html} = live(conn, ~p"/episodes")

      assert index_live |> element("#episodes-#{episode.id} a", "Edit") |> render_click() =~
               "Edit Episode"

      assert_patch(index_live, ~p"/episodes/#{episode}/edit")

      assert index_live
             |> form("#episode-form", episode: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#episode-form", episode: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/episodes")

      html = render(index_live)
      assert html =~ "Episode updated successfully"
      assert html =~ "some updated type"
    end

    test "deletes episode in listing", %{conn: conn, episode: episode} do
      {:ok, index_live, _html} = live(conn, ~p"/episodes")

      assert index_live |> element("#episodes-#{episode.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#episodes-#{episode.id}")
    end
  end

  describe "Show" do
    setup [:create_episode]

    test "displays episode", %{conn: conn, episode: episode} do
      {:ok, _show_live, html} = live(conn, ~p"/episodes/#{episode}")

      assert html =~ "Show Episode"
      assert html =~ episode.type
    end

    test "updates episode within modal", %{conn: conn, episode: episode} do
      {:ok, show_live, _html} = live(conn, ~p"/episodes/#{episode}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Episode"

      assert_patch(show_live, ~p"/episodes/#{episode}/show/edit")

      assert show_live
             |> form("#episode-form", episode: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#episode-form", episode: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/episodes/#{episode}")

      html = render(show_live)
      assert html =~ "Episode updated successfully"
      assert html =~ "some updated type"
    end
  end
end
