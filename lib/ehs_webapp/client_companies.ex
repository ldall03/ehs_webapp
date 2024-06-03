defmodule EhsWebapp.ClientCompanies do
  @moduledoc """
  The ClientCompanies context.
  """

  import Ecto.Query, warn: false
  alias EhsWebapp.Repo

  alias EhsWebapp.ClientCompanies.ClientCompany

  @doc """
  Returns the list of client_companies.

  ## Examples

      iex> list_client_companies()
      [%ClientCompany{}, ...]

  """
  def list_client_companies do
    Repo.all(ClientCompany)
  end

  @doc """
  Gets a single client_company.

  Raises `Ecto.NoResultsError` if the Client company does not exist.

  ## Examples

      iex> get_client_company!(123)
      %ClientCompany{}

      iex> get_client_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_company!(id), do: Repo.get!(ClientCompany, id)

  @doc """
  Creates a client_company.

  ## Examples

      iex> create_client_company(%{field: value})
      {:ok, %ClientCompany{}}

      iex> create_client_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_company(attrs \\ %{}) do
    %ClientCompany{}
    |> ClientCompany.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_company.

  ## Examples

      iex> update_client_company(client_company, %{field: new_value})
      {:ok, %ClientCompany{}}

      iex> update_client_company(client_company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_company(%ClientCompany{} = client_company, attrs) do
    client_company
    |> ClientCompany.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client_company.

  ## Examples

      iex> delete_client_company(client_company)
      {:ok, %ClientCompany{}}

      iex> delete_client_company(client_company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_company(%ClientCompany{} = client_company) do
    Repo.delete(client_company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_company changes.

  ## Examples

      iex> change_client_company(client_company)
      %Ecto.Changeset{data: %ClientCompany{}}

  """
  def change_client_company(%ClientCompany{} = client_company, attrs \\ %{}) do
    ClientCompany.changeset(client_company, attrs)
  end
end
