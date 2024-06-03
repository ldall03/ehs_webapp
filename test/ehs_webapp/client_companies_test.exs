defmodule EhsWebapp.ClientCompaniesTest do
  use EhsWebapp.DataCase

  alias EhsWebapp.ClientCompanies

  describe "client_companies" do
    alias EhsWebapp.ClientCompanies.ClientCompany

    import EhsWebapp.ClientCompaniesFixtures

    @invalid_attrs %{company_name: nil, contact_email: nil, contact_phone_number: nil, date_joined: nil}

    test "list_client_companies/0 returns all client_companies" do
      client_company = client_company_fixture()
      assert ClientCompanies.list_client_companies() == [client_company]
    end

    test "get_client_company!/1 returns the client_company with given id" do
      client_company = client_company_fixture()
      assert ClientCompanies.get_client_company!(client_company.id) == client_company
    end

    test "create_client_company/1 with valid data creates a client_company" do
      valid_attrs = %{company_name: "some company_name", contact_email: "some contact_email", contact_phone_number: "some contact_phone_number", date_joined: ~N[2024-06-02 15:21:00]}

      assert {:ok, %ClientCompany{} = client_company} = ClientCompanies.create_client_company(valid_attrs)
      assert client_company.company_name == "some company_name"
      assert client_company.contact_email == "some contact_email"
      assert client_company.contact_phone_number == "some contact_phone_number"
      assert client_company.date_joined == ~N[2024-06-02 15:21:00]
    end

    test "create_client_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClientCompanies.create_client_company(@invalid_attrs)
    end

    test "update_client_company/2 with valid data updates the client_company" do
      client_company = client_company_fixture()
      update_attrs = %{company_name: "some updated company_name", contact_email: "some updated contact_email", contact_phone_number: "some updated contact_phone_number", date_joined: ~N[2024-06-03 15:21:00]}

      assert {:ok, %ClientCompany{} = client_company} = ClientCompanies.update_client_company(client_company, update_attrs)
      assert client_company.company_name == "some updated company_name"
      assert client_company.contact_email == "some updated contact_email"
      assert client_company.contact_phone_number == "some updated contact_phone_number"
      assert client_company.date_joined == ~N[2024-06-03 15:21:00]
    end

    test "update_client_company/2 with invalid data returns error changeset" do
      client_company = client_company_fixture()
      assert {:error, %Ecto.Changeset{}} = ClientCompanies.update_client_company(client_company, @invalid_attrs)
      assert client_company == ClientCompanies.get_client_company!(client_company.id)
    end

    test "delete_client_company/1 deletes the client_company" do
      client_company = client_company_fixture()
      assert {:ok, %ClientCompany{}} = ClientCompanies.delete_client_company(client_company)
      assert_raise Ecto.NoResultsError, fn -> ClientCompanies.get_client_company!(client_company.id) end
    end

    test "change_client_company/1 returns a client_company changeset" do
      client_company = client_company_fixture()
      assert %Ecto.Changeset{} = ClientCompanies.change_client_company(client_company)
    end
  end
end
