defmodule TictactoexWeb.GameControllerTest do
  use TictactoexWeb.ConnCase

  import Tictactoex.GameStateFixtures

  alias Tictactoex.GameState.Game

  @create_attrs %{
    active: "some active",
    current_player_turn: "some current_player_turn",
    players: "some players",
    winner: "some winner"
  }
  @update_attrs %{
    active: "some updated active",
    current_player_turn: "some updated current_player_turn",
    players: "some updated players",
    winner: "some updated winner"
  }
  @invalid_attrs %{active: nil, current_player_turn: nil, players: nil, winner: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all table_data", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.game_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "active" => "some active",
               "current_player_turn" => "some current_player_turn",
               "players" => "some players",
               "winner" => "some winner"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update game" do
    setup [:create_game]

    test "renders game when data is valid", %{conn: conn, game: %Game{id: id} = game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.game_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "active" => "some updated active",
               "current_player_turn" => "some updated current_player_turn",
               "players" => "some updated players",
               "winner" => "some updated winner"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, Routes.game_path(conn, :delete, game))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.game_path(conn, :show, game))
      end
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
