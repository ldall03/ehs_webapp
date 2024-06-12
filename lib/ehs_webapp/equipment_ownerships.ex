defmodule EhsWebapp.EquipmentOwnerships do
  @moduledoc """
  The EquipmentOwnerships context.
  """

  import Ecto.Query, warn: false
  alias EhsWebapp.Repo

  alias EhsWebapp.EquipmentOwnerships.EquipmentOwnership
  alias EhsWebapp.ClientCompanies.ClientCompany
  alias EhsWebapp.Equipments.{Category, Subcategory, Equipment}

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

  def equipment_search(params, data \\ [])
  def equipment_search(%{
    "equipment"         => "",
    "category_id"       => "-",
    "subcategory_id"    => "-",
    "brand"             => "",
    "part_number"       => "",
    "batch_number"      => "",
    "serial_number"     => "",
    "company_name"      => "",
    "department"        => "",
    "current_owner"     => "",
    "current_owner_id"  => ""
    }, data) do
    data
  end

  def equipment_search(params, data) do
    equipment_pattern = "%#{params["equipment"]}%"
    brand_pattern = "%#{params["brand"]}%"
    client_pattern = "%#{params["company_name"]}%"
    department_pattern = "%#{params["department"]}%"
    owner_pattern = "%#{params["current_owner_id"]}%"

    query = Equipment
      |> join(:inner, [eq], sub in Subcategory, on: eq.subcategory_id == sub.id)
      |> join(:inner, [eq, sub], cat in Category, on: sub.category_id == cat.id)
      |> join(:inner, [eq, sub, cat], o in EquipmentOwnership, on: eq.id == o.equipment_id)
      |> join(:inner, [eq, sub, cat, o], com in ClientCompany, on: o.client_company_id == com.id)

    query = if params["equipment"] != "", do: query
      |> where([eq], like(eq.equipment, ^equipment_pattern)), else: query
    query = if params["category_id"] != "-", do: query
      |> where([eq, sub, cat], cat.id == ^params["category_id"]), else: query
    query = if params["subcategory_id"] != "-", do: query
      |> where([eq, sub], sub.id == ^params["subcategory_id"]), else: query
    query = if params["brand"] != "", do: query
      |> where([eq], like(eq.brand, ^brand_pattern)), else: query
    query = if params["part_number"] != "", do: query
      |> where([eq], eq.part_number == ^params["part_number"]), else: query
    query = if params["batch_number"] != "", do: query
      |> where([eq, sub, cat, o], o.batch_number == ^params["batch_number"]), else: query
    query = if params["serial_number"] != "", do: query
      |> where([eq, sub, cat, o], o.serial_number == ^params["serial_number"]), else: query
    query = if params["company_name"] != "", do: query
      |> where([eq, sub, cat, o, com], like(com.company_name, ^client_pattern)), else: query
    query = if params["department"] != "", do: query
      |> where([eq, sub, cat, o], like(o.department, ^department_pattern)), else: query
    query = if params["current_owner"] != "", do: query
      |> where([eq, sub, cat, o], like(o.current_owner, ^owner_pattern)), else: query
    query = if params["current_owner_id"] != "", do: query
      |> where([eq, sub, cat, o], o.owner_id == ^params["current_owner_id"]), else: query

    # add existing data to query to avoid duplicates
    query = Enum.reduce(data, query, fn i, acc -> acc |> or_where([eq, sub, cat, o], o.id == ^i.id) end)

    query = query
      |> select([eq, sub, cat, o, com], 
        [o.id,
        eq.equipment, 
        o.serial_number, 
        com.company_name])
      |> order_by([eq], eq.equipment)

    Repo.all(query)
      |> Enum.map(fn item -> 
        %{
          :id                   => Enum.at(item, 0),
          :equipment            => Enum.at(item, 1),
          :serial_number        => Enum.at(item, 2), 
          :client               => Enum.at(item, 3)
        } end)   
  end

  def equipment_search_by(nil) do
    %{
      :id                   => "",
      :equipment            => "",
      :brand                => "", 
      :part_number          => "",
      :serial_number        => "", 
      :mfgdt                => "",
      :client               => "",
      :department           => "",
      :owner                => "",
      :owner_id             => "",
      :service_date         => "",
      :last_inspection_date => "",
      :next_inspection_date => "",
      :inspection_interval  => "",
      :inactive_date        => "",
      :batch_number         => ""
    }
  end
  
  def equipment_search_by(id) do
    query = Equipment
      |> join(:inner, [eq], sub in Subcategory, on: eq.subcategory_id == sub.id)
      |> join(:inner, [eq, sub], cat in Category, on: sub.category_id == cat.id)
      |> join(:inner, [eq, sub, cat], o in EquipmentOwnership, on: eq.id == o.equipment_id)
      |> join(:inner, [eq, sub, cat, o], com in ClientCompany, on: o.client_company_id == com.id)
      |> where([eq, sub, cat, o], o.id == ^id)
      |> select([eq, sub, cat, o, com], 
        [o.id,
        eq.equipment, 
        eq.brand,
        eq.part_number,
        o.serial_number, 
        o.mfgdt,
        com.company_name,
        o.department,
        o.current_owner,
        o.owner_id,
        o.service_date,
        o.last_inspection_date,
        o.next_inspection_date,
        o.inspection_interval,
        o.inactive_date,
        o.batch_number])

    res = Repo.one(query)
    %{
      :id                   => Enum.at(res, 0),
      :equipment            => Enum.at(res, 1),
      :brand                => Enum.at(res, 2), 
      :part_number          => Enum.at(res, 3),
      :serial_number        => Enum.at(res, 4), 
      :mfgdt                => Enum.at(res, 5),
      :client               => Enum.at(res, 6),
      :department           => Enum.at(res, 7),
      :owner                => Enum.at(res, 8),
      :owner_id             => Enum.at(res, 9),
      :service_date         => Enum.at(res, 10),
      :last_inspection_date => Enum.at(res, 11),
      :next_inspection_date => Enum.at(res, 12),
      :inspection_interval  => Enum.at(res, 13),
      :inactive_date        => Enum.at(res, 14),
      :batch_number         => Enum.at(res, 15)
    } 
  end
end
