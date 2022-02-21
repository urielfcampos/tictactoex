defmodule Tictactoex.Factory.User do

  def user_factory do
    %Tictactoex.Account.User{
      email: "test@email.com",
      password: Bcrypt.hash_pwd_salt("some_password")
    }
  end
end
