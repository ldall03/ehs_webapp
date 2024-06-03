defmodule EhsWebapp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EhsWebapp.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> EhsWebapp.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a user_info.
  """
  def user_info_fixture(attrs \\ %{}) do
    {:ok, user_info} =
      attrs
      |> Enum.into(%{
        f_name: "some f_name",
        l_name: "some l_name",
        permissions: 42
      })
      |> EhsWebapp.Accounts.create_user_info()

    user_info
  end
end
