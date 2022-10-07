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
        active?: "some active",
        current_player_turn: "some current_player_turn",
        players: ["1", "2"],
        winner: "some winner"
      }

      assert {:ok, %Game{} = game} = GameState.create_game(valid_attrs)
      assert game.active? == false
      assert game.players == ["1", "2"]
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GameState.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      update_attrs = %{
        active?: false,
        current_player_turn: "2",
        winner: "some updated winner"
      }

      assert {:ok, %Game{} = game} = GameState.update_game(game, update_attrs)
      refute game.active?
      assert game.current_player_turn == "2"
      assert game.players == ["1", "2"]
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

    test "won?/2 returns true when a win condition occurs" do
      game = win_game_fixture()

      assert GameState.won?(game.table, "1")
    end

    test "won?/2 returns false when no win condition has occurred" do
      game = game_fixture()

      refute GameState.won?(game.table, "1")
    end

    test "play/3 updates the game table" do
      game = game_fixture()

      {:ok, table} = GameState.play(game, "1", [1, 1])

      player_id = get_in(table, ["0", "content"])
      assert player_id == "1"
    end

    test "play/3 fails when player tries to play an already played cell" do
      game = game_fixture()

      {:ok, table} = GameState.play(game, "1", [1, 1])

      updated_game = Map.put(game, :table, table)

      assert {:error, :cell_already_played} = GameState.play(updated_game, "2", [1, 1])
    end

    test "player_turn?/2 returns true when its a player's turn" do
      {:ok, game} =
        game_fixture() |> Tictactoex.GameState.update_game(%{current_player_turn: "1"})

      assert {:ok, _game} = GameState.player_turn?(game, "1")
    end

    test "player_turn?/2 returns false when its not the player's turn" do
      game = game_fixture()

      assert {:error, :not_player_turn} = GameState.player_turn?(game, "2")
    end

    test "draw?/1 returns true when there are no more possible plays" do
      game = draw_game_fixture()

      assert GameState.draw?(game.table)
    end

    test "draw?/1 returns false when there are still possible plays" do
      game = game_fixture()

      refute GameState.draw?(game.table)
    end

    test "next_player/2 returns the next player turn" do
      [player_1, player_2] = insert_pair(:user)

      game =
        insert(:game,
          players: [player_1.id, player_2.id],
          active?: true,
          current_player_turn: player_1.id
        )

      assert GameState.next_player(game, player_1.id) == player_2.id
    end

    test "empty_table/0 returns a brand new game table" do
      empty_table = GameState.empty_table()

      assert empty_table == %{
               "0" => %{"content" => "", "coordinates" => [1, 1]},
               "1" => %{"content" => "", "coordinates" => [1, 2]},
               "2" => %{"content" => "", "coordinates" => [1, 3]},
               "3" => %{"content" => "", "coordinates" => [2, 1]},
               "4" => %{"content" => "", "coordinates" => [2, 2]},
               "5" => %{"content" => "", "coordinates" => [2, 3]},
               "6" => %{"content" => "", "coordinates" => [3, 1]},
               "7" => %{"content" => "", "coordinates" => [3, 2]},
               "8" => %{"content" => "", "coordinates" => [3, 3]}
             }
    end
  end
end
