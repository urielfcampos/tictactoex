defmodule TictactoexWeb.Plugs.SetUserId do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    case get_session(conn, :player_id) do
      nil ->
        unique_id = Ecto.UUID.generate()
        put_session(conn, :player_id, unique_id)

      _player_id ->
        conn
    end
  end
end
