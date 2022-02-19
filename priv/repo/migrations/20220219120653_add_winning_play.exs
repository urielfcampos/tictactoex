defmodule Tictactoex.Repo.Migrations.AddWinningPlayAndGameStatus do
  use Ecto.Migration

  def up do
    alter table(:game) do
      add :status, :string
      add :winning_play, {:array, {:array, :integer}}, default: nil
    end
  end

  def down do
    alter table(:game) do
      remove :status, :string
      remove :winning_play, {:array, :integer}
    end
  end
end
