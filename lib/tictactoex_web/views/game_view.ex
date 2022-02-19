defmodule TictactoexWeb.GameView do
  use TictactoexWeb, :view
  alias TictactoexWeb.GameView

  def render("index.json", %{table_data: table_data}) do
    %{data: render_many(table_data, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{
      id: game.id,
      table: game.table,
      current_player_turn: game.current_player_turn,
      active?: game.active?,
      winner: game.winner,
      players: game.players
    }
  end

  def render("error.json", %{error_message: error}) do
    %{errors: %{detail: error}}
  end
end
