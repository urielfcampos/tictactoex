defmodule Tictactoex.GameState.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game" do
    field :table, :map
    field :active?, :boolean
    field :current_player_turn, :string
    field :players, {:array, :string}
    field :winner, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> set_values()
    |> cast(attrs, [:players])
    |> validate_required([:players])
    |> validate_player_size(attrs)
  end

  def create_changeset(game, attrs) do
    game
    |> set_values()
    |> cast(attrs, [:players])
    |> validate_required([:players])
  end

  def set_values(%__MODULE__{} = game) do
    game
    |> Map.put(:table, empty_game_table())
    |> Map.put(:active?, false)
  end

  defp empty_game_table do
    %{
      table: []
    }
  end

  @max_player_count 2
  defp validate_player_size(game, %{"players" => players}) do
    if length(players) > @max_player_count do
      Ecto.Changeset.add_error(
        game,
        :players,
        "Can't have more than #{@max_player_count} players"
      )
    else
      game
    end
  end
end
