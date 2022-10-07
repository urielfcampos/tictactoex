defmodule Tictactoex.Factory.Game do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def game_factory do
        %Tictactoex.GameState.Game{
          table: Tictactoex.GameState.empty_table(),
          active?: false,
          current_player_turn: nil,
          players: nil,
          winner: nil,
          status: nil,
          winning_play: nil
        }
      end
    end
  end
end
