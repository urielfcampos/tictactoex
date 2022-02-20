defmodule Tictactoex.Account.User do
  @moduledoc """
    Schema for saving and manipulating user accounts
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :bare_password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :bare_password])
    |> validate_required([:email, :bare_password])
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true} = user) do
    bare_password = Ecto.Changeset.get_change(user, :bare_password)
    change(user, Bcrypt.add_hash(bare_password, hash_key: :password))
  end

  defp hash_password(changeset), do: add_error(changeset, :password, "Couldn't hash password")
end
