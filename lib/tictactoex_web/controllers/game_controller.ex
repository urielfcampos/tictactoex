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

  def join(conn, %{"game_id" => id}) do
    game = GameState.get_game!(id)
    player_id = get_session(conn, :player_id)
    start_status = Tictactoex.GameState.GameStatus.get_status(:start, "start")

    if player_id in game.players do
      render(conn, "error.json", error_message: "Can't join a game you're already in")
    else
      players = [player_id | game.players]

      game_params = %{
        "players" => players,
        "active?" => true,
        "status" => start_status,
        "current_player_turn" => List.last(players)
      }

      with {:ok, %Game{} = game} <- GameState.update_game(game, game_params) do
        render(conn, "show.json", game: game)
      end
    end
  end

  def play(conn, %{"game_id" => id, "play" => play}) do
    game = GameState.get_game!(id)
    player_id = get_session(conn, :player_id)

    if player_id not in game.players do
      render(conn, "error.json", error_message: "You are not participating in this match")
    else
      game_params = do_play(play, game, player_id)

      case game_params do
        {:error, :not_player_turn} ->
          render(conn, "error.json", error_message: "It's not your turn")

        {:error, :cell_already_played} ->
          render(conn, "error.json", error_message: "Can't play this cell")

        params ->
          with {:ok, %Game{} = game} <- GameState.update_game(game, params) do
            render(conn, "show.json", game: game)
          end
      end
    end
  end

  defp do_play(play, game, player_id) do
    with {:ok, game} <- GameState.player_turn?(game, player_id),
         {:ok, new_table} <- GameState.play(game, player_id, play) do
      case GameState.won?(new_table, player_id) do
        {true, play} ->
          %{
            "table" => new_table,
            "current_player_turn" => GameState.next_player(game, player_id),
            "winner" => player_id,
            "winning_play" => play
          }

        {false, _} ->
          %{
            "table" => new_table,
            "current_player_turn" => GameState.next_player(game, player_id)
          }
      end
    else
      {:error, error} ->
        handle_error(game, error)
    end
  end

  defp handle_error(game, error) do
    if GameState.draw?(game.table) do
      status = Tictactoex.GameState.GameStatus.get_status(:final, "draw")
      %{"status" => status}
    else
      {:error, error}
    end
  end
end
