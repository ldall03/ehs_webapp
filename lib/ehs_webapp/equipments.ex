defmodule EhsWebapp.Equipments do
  @moduledoc """
  The Equipments context.
  """

  import Ecto.Query, warn: false
  alias EhsWebapp.Repo

  alias EhsWebapp.Equipments.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias EhsWebapp.Equipments.Subcategory

  @doc """
  Returns the list of subcategories under parent_id

  ## Examples

      iex> list_subcategories()
      [%Subcategory{}, ...]

  """
  def list_subcategories(parent_id) do
    Repo.all(from sub in Subcategory,
      where: sub.category_id == ^parent_id,
      order_by: sub.subcategory)
  end

  @doc """
  Creates a subcategory.

  ## Examples

      iex> create_subcategory(%{field: value})
      {:ok, %Subcategory{}}

      iex> create_subcategory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subcategory(attrs \\ %{}) do
    %Subcategory{}
    |> Subcategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subcategory.

  ## Examples

      iex> update_subcategory(subcategory, %{field: new_value})
      {:ok, %Subcategory{}}

      iex> update_subcategory(subcategory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subcategory(%Subcategory{} = subcategory, attrs) do
    subcategory
    |> Subcategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subcategory.

  ## Examples

      iex> delete_subcategory(subcategory)
      {:ok, %Subcategory{}}

      iex> delete_subcategory(subcategory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subcategory(%Subcategory{} = subcategory) do
    Repo.delete(subcategory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subcategory changes.

  ## Examples

      iex> change_subcategory(subcategory)
      %Ecto.Changeset{data: %Subcategory{}}

  """
  def change_subcategory(%Subcategory{} = subcategory, attrs \\ %{}) do
    Subcategory.changeset(subcategory, attrs)
  end

  alias EhsWebapp.Equipments.Equipment

  @doc """
  Returns the list of equipments.

  ## Examples

      iex> list_equipments()
      [%Equipment{}, ...]

  """
  def list_equipments do
    Repo.all(Equipment)
  end

  @doc """
  Gets a single equipment.

  Raises `Ecto.NoResultsError` if the Equipment does not exist.

  ## Examples

      iex> get_equipment!(123)
      %Equipment{}

      iex> get_equipment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_equipment!(id), do: Repo.get!(Equipment, id)

  @doc """
  Creates a equipment.

  ## Examples

      iex> create_equipment(%{field: value})
      {:ok, %Equipment{}}

      iex> create_equipment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_equipment(attrs \\ %{}) do
    %Equipment{}
    |> Equipment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a equipment.

  ## Examples

      iex> update_equipment(equipment, %{field: new_value})
      {:ok, %Equipment{}}

      iex> update_equipment(equipment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_equipment(%Equipment{} = equipment, attrs) do
    equipment
    |> Equipment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a equipment.

  ## Examples

      iex> delete_equipment(equipment)
      {:ok, %Equipment{}}

      iex> delete_equipment(equipment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_equipment(%Equipment{} = equipment) do
    Repo.delete(equipment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking equipment changes.

  ## Examples

      iex> change_equipment(equipment)
      %Ecto.Changeset{data: %Equipment{}}

  """
  def change_equipment(%Equipment{} = equipment, attrs \\ %{}) do
    Equipment.changeset(equipment, attrs)
  end

  def equipment_search(params, data \\ []) do
    equipment_pattern = "%#{params.equipment}%"
    brand_pattern = "%#{params.brand}%"
    client_pattern = "%#{params.client}%"
    department_pattern = "%#{params.department}%"
    owner_pattern = "%#{params.current_owner}%"

    query = Equipment
      |> join(:inner, [eq], sub in Subcategory, on: eq.subcategory == sub.id)
      |> join(:inner, [eq, sub], cat in Category, on: sub.category_id == cat.id)
      |> join(:inner, [eq, sub, cat], o in EquipmentOwnership, on: eq.id == o.equipment_id)
      |> join(:inner, [eq, sub, cat, o], com in ClientCompany, on: o.client_company_id == com.id)

    query = if params["equipment"] != "", do: query
      |> where([eq], like(eq.equipment, ^equipment_pattern)), else: query
    query = if params["category"] != "", do: query
      |> where([cat], cat.id, ^params["category"]), else: query
    query = if params["subcategory"] != "", do: query
      |> where([sub], sub.id, ^params["subcategory"]), else: query
    query = if params["subcategory"] != "", do: query
      |> where([eq], like(eq.brand, ^brand_pattern)), else: query
    query = if params["part_no"] != "", do: query
      |> where([eq], eq.part_no, ^params["part_no"]), else: query
    query = if params["batch_no"] != "", do: query
      |> where([o], o.batch_no, ^params["batch_no"]), else: query
    query = if params["serial_no"] != "", do: query
      |> where([o], o.serial_no, ^params["serial_no"]), else: query
    query = if params["client"] != "", do: query
      |> where([com], like(com.company_name, ^client_pattern)), else: query
    query = if params["department"] != "", do: query
      |> where([o], like(o.department, ^department_pattern)), else: query
    query = if params["current_owner"] != "", do: query
      |> where([o], like(o.current_owner, ^owner_pattern)), else: query
    query = if params["owner_id"] != "", do: query
      |> where([o], o.owner_id, ^params["owner_id"]), else: query

    # add existing data to query to avoid duplicates
    query = Enum.reduce(data, query, fn i, acc -> acc |> or_where([eq], eq.id = Enum.at(i, 0)) end)

    query = query
      |> select([eq, sub, cat, o, com], [e.id, e.equipment, e.serial_no, com.company_name])
      |> order_by([eq], eq.equipment)

     Repo.all(query)
  end
end
