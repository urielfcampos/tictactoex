defmodule Tictactoex.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tictactoex.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password: "some password"
      })
      |> Tictactoex.Account.create_user()

    user
  end
end
