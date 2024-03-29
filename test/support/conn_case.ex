defmodule TictactoexWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use TictactoexWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import TictactoexWeb.ConnCase
      import Tictactoex.Factory
      alias TictactoexWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint TictactoexWeb.Endpoint
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Tictactoex.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

    if tags[:authenticated] do
      user = Tictactoex.Factory.insert(:user)
      {:ok, token, _} = Tictactoex.Guardian.encode_and_sign(user)

      conn =
        Phoenix.ConnTest.build_conn()
        |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")

      {:ok, conn: conn, auth_user: user}
    else
      {:ok, conn: Phoenix.ConnTest.build_conn()}
    end
  end
end
