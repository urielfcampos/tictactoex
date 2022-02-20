defmodule Tictactoex.GameStateTest do
  use Tictactoex.DataCase

  alias Tictactoex.GameState

  describe "table_data" do
    alias Tictactoex.GameState.Game

    import Tictactoex.GameStateFixtures

    @invalid_attrs %{active: nil, current_player_turn: nil, players: nil, winner: nil}

    test "list_games/0 returns all table_data" do
      game = game_fixture()
      assert GameState.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert GameState.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{
        active: "some active",
        current_player_turn: "some current_player_turn",
        players: "some players",
        winner: "some winner"
      }

      assert {:ok, %Game{} = game} = GameState.create_game(valid_attrs)
      assert game.active == "some active"
      assert game.current_player_turn == "some current_player_turn"
      assert game.players == "some players"
      assert game.winner == "some winner"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GameState.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      update_attrs = %{
        active: "some updated active",
        current_player_turn: "some updated current_player_turn",
        players: "some updated players",
        winner: "some updated winner"
      }

      assert {:ok, %Game{} = game} = GameState.update_game(game, update_attrs)
      assert game.active == "some updated active"
      assert game.current_player_turn == "some updated current_player_turn"
      assert game.players == "some updated players"
      assert game.winner == "some updated winner"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = GameState.update_game(game, @invalid_attrs)
      assert game == GameState.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = GameState.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> GameState.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = GameState.change_game(game)
    end
  end
end
