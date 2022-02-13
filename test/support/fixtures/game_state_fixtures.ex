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
        active: "some active",
        current_player_turn: "some current_player_turn",
        players: "some players",
        winner: "some winner"
      })
      |> Tictactoex.GameState.create_game()

    game
  end
end
