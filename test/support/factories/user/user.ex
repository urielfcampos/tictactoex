defmodule Tictactoex.Factory.User do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        random_email_number = :rand.uniform(100)

        %Tictactoex.Account.User{
          email: "test_#{random_email_number}@email.com",
          password: Bcrypt.hash_pwd_salt("some_password")
        }
      end
    end
  end
end
