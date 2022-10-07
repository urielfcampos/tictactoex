defmodule Tictactoex.GameState do
  @moduledoc """
  The GameState context.
  """

  import Ecto.Query, warn: false
  alias Tictactoex.Repo

  alias Tictactoex.GameState.Game

  @doc """
  Returns the list of table_data.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  @doc """
  Returns an `{:ok, game}` if the player_id matches the current_player_turn
  else returns {:error, :not_player_turn}

  """
  def player_turn?(game, player_id) do
    if game.current_player_turn == player_id do
      {:ok, game}
    else
      {:error, :not_player_turn}
    end
  end

  @doc """
  Returns an updated game table with the given play
  if the cell already has a play, it returns {:error, :cell_already_played}
  """
  def play(game, player_id, play) do
    current_table = game.table

    {index, cell} = Enum.find(current_table, fn {_k, v} -> v["coordinates"] == play end)

    case cell["content"] do
      "" ->
        new_cell = %{"content" => player_id, "coordinates" => cell["coordinates"]}
        {:ok, Map.replace(current_table, index, new_cell)}

      _ ->
        {:error, :cell_already_played}
    end
  end

  @doc """
  Returns a boolean to indicate if the current table has a win condition
  """
  def won?(table, current_player) do
    table_grouped =
      Enum.group_by(table, fn {_, row} -> row["content"] end, fn {_, row} ->
        row["coordinates"]
      end)

    check_win(table_grouped[current_player])
  end

  @doc """
  Returns a boolean to indicate if the current table has a draw condition
  """
  def draw?(table) do
    Enum.all?(table, fn {_, row} -> row["content"] != "" end)
  end

  @doc """
  Returns the next player in the game
  """
  def next_player(game, player_id) do
    Enum.find(game.players, &(&1 != player_id))
  end

  def empty_table do
    all_cells =
      for x <- 1..3, y <- 1..3 do
        %{"coordinates" => [x, y], "content" => ""}
      end

    all_cells
    |> Enum.with_index()
    |> Enum.into(%{}, fn {k, v} -> {Integer.to_string(v), k} end)
  end

  defp check_win(nil), do: false

  defp check_win(player_moves) do
    play_count = length(player_moves)

    cond do
      play_count > 3 ->
        all_combinations = Comb.combinations(player_moves, 3)
        match_check = find_win_condition(all_combinations)
        if match_check, do: {true, match_check}, else: {false, []}

      play_count == 3 ->
        match_check = find_win_condition([player_moves])
        if match_check, do: {true, match_check}, else: {false, []}

      play_count < 3 ->
        {false, []}
    end
  end

  defp find_win_condition(elements) do
    Enum.find(elements, false, fn el ->
      case el do
        [[x, _a], [x, _b], [x, _c]] -> true
        [[_a, x], [_b, x], [_c, x]] -> true
        _ -> false
      end
    end)
  end
end
