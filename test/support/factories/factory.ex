defmodule Tictactoex.Factory do
  use ExMachina.Ecto, repo: Tictactoex.Repo

  use Tictactoex.Factory.User
  use Tictactoex.Factory.Game
end
