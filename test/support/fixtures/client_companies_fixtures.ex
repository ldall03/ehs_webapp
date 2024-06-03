defmodule EhsWebapp.ClientCompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EhsWebapp.ClientCompanies` context.
  """

  @doc """
  Generate a client_company.
  """
  def client_company_fixture(attrs \\ %{}) do
    {:ok, client_company} =
      attrs
      |> Enum.into(%{
        company_name: "some company_name",
        contact_email: "some contact_email",
        contact_phone_number: "some contact_phone_number",
        date_joined: ~N[2024-06-02 15:21:00]
      })
      |> EhsWebapp.ClientCompanies.create_client_company()

    client_company
  end
end
