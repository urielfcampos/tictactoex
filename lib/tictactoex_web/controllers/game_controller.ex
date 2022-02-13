defmodule TictactoexWeb.GameController do
  use TictactoexWeb, :controller

  alias Tictactoex.GameState
  alias Tictactoex.GameState.Game

  action_fallback TictactoexWeb.FallbackController

  def index(conn, _params) do
    table_data = GameState.list_games()

    render(conn, "index.json", table_data: table_data)
  end

  def create(conn, _params) do
    player_id = get_session(conn, :player_id)
    game_params = %{"players" => [player_id]}

    with {:ok, %Game{} = game} <- GameState.create_game(game_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.game_path(conn, :show, game))
      |> render("show.json", game: game)
    end
  end

  def show(conn, %{"id" => id}) do
    game = GameState.get_game!(id)
    render(conn, "show.json", game: game)
  end

  def join(conn, %{"id" => id}) do
    game = GameState.get_game!(id)
    player_id = get_session(conn, :player_id)
    players = [player_id | game.players]
    game_params = %{"players" => players}

    with {:ok, %Game{} = game} <- GameState.update_game(game, game_params) do
      render(conn, "show.json", game: game)
    end
  end

  def play(conn, %{"id" => id}) do
    game = GameState.get_game!(id)
    player_id = get_session(conn, :player_id)
    players = [player_id | game.players]
    game_params = %{"players" => players}

    with {:ok, %Game{} = game} <- GameState.update_game(game, game_params) do
      render(conn, "show.json", game: game)
    end
  end

end
