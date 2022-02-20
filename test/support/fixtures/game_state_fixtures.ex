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
end
