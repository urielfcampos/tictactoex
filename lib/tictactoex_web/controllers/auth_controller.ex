defmodule TictactoexWeb.AuthController do
  use TictactoexWeb, :controller

  def create(conn, %{"email" => email, "password" => password}) do
    case Tictactoex.Account.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, claims} = Tictactoex.Guardian.encode_and_sign(user)
        IO.inspect(token)
        IO.inspect(claims)
        render(conn, "show.json", token: token)

      {:error, :invalid_credentials} ->
        render(conn, "error.json", error_message: "Invalid login information")
    end
  end

  def delete(conn, _params) do
    token = Tictactoex.Guardian.Plug.current_token(conn)
    IO.inspect(token)
    result = Tictactoex.Guardian.revoke(token)

    IO.inspect(result)
    send_resp(conn, :no_content, "")
  end
end
