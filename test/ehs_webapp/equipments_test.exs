defmodule EhsWebapp.EquipmentsTest do
  use EhsWebapp.DataCase

  alias EhsWebapp.Equipments

  describe "categories" do
    alias EhsWebapp.Equipments.Category

    import EhsWebapp.EquipmentsFixtures

    @invalid_attrs %{category: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Equipments.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Equipments.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{category: "some category"}

      assert {:ok, %Category{} = category} = Equipments.create_category(valid_attrs)
      assert category.category == "some category"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Equipments.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{category: "some updated category"}

      assert {:ok, %Category{} = category} = Equipments.update_category(category, update_attrs)
      assert category.category == "some updated category"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Equipments.update_category(category, @invalid_attrs)
      assert category == Equipments.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Equipments.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Equipments.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Equipments.change_category(category)
    end
  end

  describe "subcategories" do
    alias EhsWebapp.Equipments.Subcategory

    import EhsWebapp.EquipmentsFixtures

    @invalid_attrs %{subcategory: nil}

    test "list_subcategories/0 returns all subcategories" do
      subcategory = subcategory_fixture()
      assert Equipments.list_subcategories() == [subcategory]
    end

    test "get_subcategory!/1 returns the subcategory with given id" do
      subcategory = subcategory_fixture()
      assert Equipments.get_subcategory!(subcategory.id) == subcategory
    end

    test "create_subcategory/1 with valid data creates a subcategory" do
      valid_attrs = %{subcategory: "some subcategory"}

      assert {:ok, %Subcategory{} = subcategory} = Equipments.create_subcategory(valid_attrs)
      assert subcategory.subcategory == "some subcategory"
    end

    test "create_subcategory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Equipments.create_subcategory(@invalid_attrs)
    end

    test "update_subcategory/2 with valid data updates the subcategory" do
      subcategory = subcategory_fixture()
      update_attrs = %{subcategory: "some updated subcategory"}

      assert {:ok, %Subcategory{} = subcategory} = Equipments.update_subcategory(subcategory, update_attrs)
      assert subcategory.subcategory == "some updated subcategory"
    end

    test "update_subcategory/2 with invalid data returns error changeset" do
      subcategory = subcategory_fixture()
      assert {:error, %Ecto.Changeset{}} = Equipments.update_subcategory(subcategory, @invalid_attrs)
      assert subcategory == Equipments.get_subcategory!(subcategory.id)
    end

    test "delete_subcategory/1 deletes the subcategory" do
      subcategory = subcategory_fixture()
      assert {:ok, %Subcategory{}} = Equipments.delete_subcategory(subcategory)
      assert_raise Ecto.NoResultsError, fn -> Equipments.get_subcategory!(subcategory.id) end
    end

    test "change_subcategory/1 returns a subcategory changeset" do
      subcategory = subcategory_fixture()
      assert %Ecto.Changeset{} = Equipments.change_subcategory(subcategory)
    end
  end

  describe "equipments" do
    alias EhsWebapp.Equipments.Equipment

    import EhsWebapp.EquipmentsFixtures

    @invalid_attrs %{description: nil, brand: nil}

    test "list_equipments/0 returns all equipments" do
      equipment = equipment_fixture()
      assert Equipments.list_equipments() == [equipment]
    end

    test "get_equipment!/1 returns the equipment with given id" do
      equipment = equipment_fixture()
      assert Equipments.get_equipment!(equipment.id) == equipment
    end

    test "create_equipment/1 with valid data creates a equipment" do
      valid_attrs = %{description: "some description", brand: "some brand"}

      assert {:ok, %Equipment{} = equipment} = Equipments.create_equipment(valid_attrs)
      assert equipment.description == "some description"
      assert equipment.brand == "some brand"
    end

    test "create_equipment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Equipments.create_equipment(@invalid_attrs)
    end

    test "update_equipment/2 with valid data updates the equipment" do
      equipment = equipment_fixture()
      update_attrs = %{description: "some updated description", brand: "some updated brand"}

      assert {:ok, %Equipment{} = equipment} = Equipments.update_equipment(equipment, update_attrs)
      assert equipment.description == "some updated description"
      assert equipment.brand == "some updated brand"
    end

    test "update_equipment/2 with invalid data returns error changeset" do
      equipment = equipment_fixture()
      assert {:error, %Ecto.Changeset{}} = Equipments.update_equipment(equipment, @invalid_attrs)
      assert equipment == Equipments.get_equipment!(equipment.id)
    end

    test "delete_equipment/1 deletes the equipment" do
      equipment = equipment_fixture()
      assert {:ok, %Equipment{}} = Equipments.delete_equipment(equipment)
      assert_raise Ecto.NoResultsError, fn -> Equipments.get_equipment!(equipment.id) end
    end

    test "change_equipment/1 returns a equipment changeset" do
      equipment = equipment_fixture()
      assert %Ecto.Changeset{} = Equipments.change_equipment(equipment)
    end
  end
end
