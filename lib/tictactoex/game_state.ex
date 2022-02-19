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

  def player_turn?(game, player_id) do
    if game.current_player_turn == player_id do
      {:ok, game}
    else
      {:error, :not_player_turn}
    end
  end

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

  def won?(table, current_player) do
    table_grouped =
      Enum.group_by(table, fn {_, v} -> v["content"] end, fn {_, v} -> v["coordinates"] end)

    play_count = length(table_grouped[current_player])

    cond do
      play_count > 3 ->
        all_combinations = Comb.combinations(table_grouped[current_player], 3)
        match_line_or_column(all_combinations)

      play_count == 3 ->
        match_line_or_column([table_grouped[current_player]])

      play_count <= 2 ->
        {false, []}
    end
  end

  def draw?(table) do
    Enum.all?(table, fn {_, v} -> v["content"] == "" end)
  end

  def match_line_or_column(elements) do
    Enum.find(elements, fn el ->
      case el do
        [[x, _], [x, _], [x, _]] ->
          true

        [[_, x], [_, x], [_, x]] ->
          true

        _ ->
          false
      end
    end)
  end

  def next_player(game, player_id) do
    Enum.find(game.players, &(&1 != player_id))
  end

  def empty_table do
    all_cells =
      for x <- 1..3, y <- 1..3 do
        %{coordinates: [x, y], content: ""}
      end

    all_cells
    |> Enum.with_index()
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
  end
end
