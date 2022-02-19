defmodule TictactoexWeb.AuthView do
  use TictactoexWeb, :view

  def render("show.json", %{token: token}) do
    %{data: token}
  end

  def render("error.json", %{error_message: error}) do
    %{errors: %{detail: error}}
  end
end
