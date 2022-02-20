defmodule Tictactoex.GameState.GameStatus do
  @moduledoc """
    GameStatus handle returning the matching game status
  """

  @statuses %{start: ["start"], in_progress: ["in_progress"], final: ["won", "draw"]}

  @spec get_status(atom(), String.t()) :: String.t()
  def get_status(status_type, status) do
    Map.get(@statuses, status_type) |> Enum.find(&(&1 == status))
  end
end
