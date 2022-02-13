defmodule Tictactoex.Repo do
  use Ecto.Repo,
    otp_app: :tictactoex,
    adapter: Ecto.Adapters.Postgres
end
