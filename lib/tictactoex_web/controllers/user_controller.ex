defmodule TictactoexWeb.UserController do
  use TictactoexWeb, :controller

  alias Tictactoex.Account
  alias Tictactoex.Account.User

  action_fallback TictactoexWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    params = %{"email" => user_params["email"], "bare_password" => user_params["password"]}

    with {:ok, %User{} = user} <- Account.create_user(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
