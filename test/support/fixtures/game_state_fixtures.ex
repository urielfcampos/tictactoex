defmodule Tictactoex.GameStateFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tictactoex.GameState` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        active?: true,
        current_player_turn: "1",
        players: ["1", "2"],
        winner: "1",
        table: Tictactoex.GameState.empty_table()
      })
      |> Tictactoex.GameState.create_game()

    game
  end

  def win_game_fixture(attrs \\ %{}) do
    empty_table = Tictactoex.GameState.empty_table()

    new_table =
      Enum.reduce(empty_table, %{}, fn {row_number, row}, acc ->
        case row_number do
          row_number when row_number in ["1", "2", "3"] ->
            row = Map.put(row, "content", "1")
            Map.put(acc, row_number, row)

          _ ->
            Map.put(acc, row_number, row)
        end
      end)

    attrs = Map.put(attrs, :table, new_table)
    game = game_fixture(attrs)

    game
  end

  def draw_game_fixture(attrs \\ %{}) do
    empty_table = Tictactoex.GameState.empty_table()

    new_table =
      Enum.reduce(empty_table, %{}, fn {row_number, row}, acc ->
        case row_number do
          row_number when row_number in ["0", "2", "4", "7"] ->
            row = Map.put(row, "content", "1")
            Map.put(acc, row_number, row)

          _ ->
            row = Map.put(row, "content", "2")
            Map.put(acc, row_number, row)
        end
      end)

    attrs = Map.put(attrs, :table, new_table)
    game = game_fixture(attrs)

    game
  end
end
