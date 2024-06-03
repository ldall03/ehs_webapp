defmodule EhsWebapp.EquipmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EhsWebapp.Equipments` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        category: "some category"
      })
      |> EhsWebapp.Equipments.create_category()

    category
  end

  @doc """
  Generate a subcategory.
  """
  def subcategory_fixture(attrs \\ %{}) do
    {:ok, subcategory} =
      attrs
      |> Enum.into(%{
        subcategory: "some subcategory"
      })
      |> EhsWebapp.Equipments.create_subcategory()

    subcategory
  end

  @doc """
  Generate a equipment.
  """
  def equipment_fixture(attrs \\ %{}) do
    {:ok, equipment} =
      attrs
      |> Enum.into(%{
        brand: "some brand",
        description: "some description"
      })
      |> EhsWebapp.Equipments.create_equipment()

    equipment
  end
end
