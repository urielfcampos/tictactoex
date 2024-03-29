defmodule Tictactoex.AccountTest do
  use Tictactoex.DataCase

  alias Tictactoex.Account

  describe "users" do
    alias Tictactoex.Account.User

    @invalid_attrs %{email: nil, password: nil}

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      db_user = Account.get_user!(user.id)
      assert db_user == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", bare_password: "some password"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.email == "some email"
      refute user.password == ""
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      update_attrs = %{email: "some updated email", bare_password: "some updated password"}

      assert {:ok, %User{} = updated_user} = Account.update_user(user, update_attrs)
      assert updated_user.email == "some updated email"
      refute updated_user.password == user.password
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
