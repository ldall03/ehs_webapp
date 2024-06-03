defmodule EhsWebapp.EquipmentOwnerships do
  @moduledoc """
  The EquipmentOwnerships context.
  """

  import Ecto.Query, warn: false
  alias EhsWebapp.Repo

  alias EhsWebapp.EquipmentOwnerships.EquipmentOwnership

  @doc """
  Returns the list of equipment_ownerships.

  ## Examples

      iex> list_equipment_ownerships()
      [%EquipmentOwnership{}, ...]

  """
  def list_equipment_ownerships do
    Repo.all(EquipmentOwnership)
  end

  @doc """
  Gets a single equipment_ownership.

  Raises `Ecto.NoResultsError` if the Equipment ownership does not exist.

  ## Examples

      iex> get_equipment_ownership!(123)
      %EquipmentOwnership{}

      iex> get_equipment_ownership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_equipment_ownership!(id), do: Repo.get!(EquipmentOwnership, id)

  @doc """
  Creates a equipment_ownership.

  ## Examples

      iex> create_equipment_ownership(%{field: value})
      {:ok, %EquipmentOwnership{}}

      iex> create_equipment_ownership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_equipment_ownership(attrs \\ %{}) do
    %EquipmentOwnership{}
    |> EquipmentOwnership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a equipment_ownership.

  ## Examples

      iex> update_equipment_ownership(equipment_ownership, %{field: new_value})
      {:ok, %EquipmentOwnership{}}

      iex> update_equipment_ownership(equipment_ownership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_equipment_ownership(%EquipmentOwnership{} = equipment_ownership, attrs) do
    equipment_ownership
    |> EquipmentOwnership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a equipment_ownership.

  ## Examples

      iex> delete_equipment_ownership(equipment_ownership)
      {:ok, %EquipmentOwnership{}}

      iex> delete_equipment_ownership(equipment_ownership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_equipment_ownership(%EquipmentOwnership{} = equipment_ownership) do
    Repo.delete(equipment_ownership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking equipment_ownership changes.

  ## Examples

      iex> change_equipment_ownership(equipment_ownership)
      %Ecto.Changeset{data: %EquipmentOwnership{}}

  """
  def change_equipment_ownership(%EquipmentOwnership{} = equipment_ownership, attrs \\ %{}) do
    EquipmentOwnership.changeset(equipment_ownership, attrs)
  end
end
