defmodule Tictactoex.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :table, {:map, :string}
      add :current_player_turn, :string
      add :active?, :boolean
      add :winner, :string
      add :players, {:array, :string}

      timestamps()
    end
  end
end
