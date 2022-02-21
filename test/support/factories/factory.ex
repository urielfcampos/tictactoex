defmodule Tictactoex.Factory do
  use ExMachina.Ecto, repo: Tictactoex.Repo

  def user_factory do
    %Tictactoex.Account.User{
      email: "test@email.com",
      password: Bcrypt.hash_pwd_salt("some_password")
    }
  end
end
