defmodule EhsWebapp.EquipmentOwnershipsTest do
  use EhsWebapp.DataCase

  alias EhsWebapp.EquipmentOwnerships

  describe "equipment_ownerships" do
    alias EhsWebapp.EquipmentOwnerships.EquipmentOwnership

    import EhsWebapp.EquipmentOwnershipsFixtures

    @invalid_attrs %{serial_number: nil, batch_number: nil, mfgdt: nil, shelf_date: nil, inspection_interval: nil, delivery_date: nil, service_date: nil, last_inspection_date: nil, next_inspection_date: nil, department: nil, current_owner: nil, owner_id: nil, inactive_date: nil}

    test "list_equipment_ownerships/0 returns all equipment_ownerships" do
      equipment_ownership = equipment_ownership_fixture()
      assert EquipmentOwnerships.list_equipment_ownerships() == [equipment_ownership]
    end

    test "get_equipment_ownership!/1 returns the equipment_ownership with given id" do
      equipment_ownership = equipment_ownership_fixture()
      assert EquipmentOwnerships.get_equipment_ownership!(equipment_ownership.id) == equipment_ownership
    end

    test "create_equipment_ownership/1 with valid data creates a equipment_ownership" do
      valid_attrs = %{serial_number: "some serial_number", batch_number: 42, mfgdt: "some mfgdt", shelf_date: ~D[2024-06-02], inspection_interval: 42, delivery_date: ~D[2024-06-02], service_date: ~D[2024-06-02], last_inspection_date: ~D[2024-06-02], next_inspection_date: ~D[2024-06-02], department: "some department", current_owner: "some current_owner", owner_id: "some owner_id", inactive_date: ~D[2024-06-02]}

      assert {:ok, %EquipmentOwnership{} = equipment_ownership} = EquipmentOwnerships.create_equipment_ownership(valid_attrs)
      assert equipment_ownership.serial_number == "some serial_number"
      assert equipment_ownership.batch_number == 42
      assert equipment_ownership.mfgdt == "some mfgdt"
      assert equipment_ownership.shelf_date == ~D[2024-06-02]
      assert equipment_ownership.inspection_interval == 42
      assert equipment_ownership.delivery_date == ~D[2024-06-02]
      assert equipment_ownership.service_date == ~D[2024-06-02]
      assert equipment_ownership.last_inspection_date == ~D[2024-06-02]
      assert equipment_ownership.next_inspection_date == ~D[2024-06-02]
      assert equipment_ownership.department == "some department"
      assert equipment_ownership.current_owner == "some current_owner"
      assert equipment_ownership.owner_id == "some owner_id"
      assert equipment_ownership.inactive_date == ~D[2024-06-02]
    end

    test "create_equipment_ownership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EquipmentOwnerships.create_equipment_ownership(@invalid_attrs)
    end

    test "update_equipment_ownership/2 with valid data updates the equipment_ownership" do
      equipment_ownership = equipment_ownership_fixture()
      update_attrs = %{serial_number: "some updated serial_number", batch_number: 43, mfgdt: "some updated mfgdt", shelf_date: ~D[2024-06-03], inspection_interval: 43, delivery_date: ~D[2024-06-03], service_date: ~D[2024-06-03], last_inspection_date: ~D[2024-06-03], next_inspection_date: ~D[2024-06-03], department: "some updated department", current_owner: "some updated current_owner", owner_id: "some updated owner_id", inactive_date: ~D[2024-06-03]}

      assert {:ok, %EquipmentOwnership{} = equipment_ownership} = EquipmentOwnerships.update_equipment_ownership(equipment_ownership, update_attrs)
      assert equipment_ownership.serial_number == "some updated serial_number"
      assert equipment_ownership.batch_number == 43
      assert equipment_ownership.mfgdt == "some updated mfgdt"
      assert equipment_ownership.shelf_date == ~D[2024-06-03]
      assert equipment_ownership.inspection_interval == 43
      assert equipment_ownership.delivery_date == ~D[2024-06-03]
      assert equipment_ownership.service_date == ~D[2024-06-03]
      assert equipment_ownership.last_inspection_date == ~D[2024-06-03]
      assert equipment_ownership.next_inspection_date == ~D[2024-06-03]
      assert equipment_ownership.department == "some updated department"
      assert equipment_ownership.current_owner == "some updated current_owner"
      assert equipment_ownership.owner_id == "some updated owner_id"
      assert equipment_ownership.inactive_date == ~D[2024-06-03]
    end

    test "update_equipment_ownership/2 with invalid data returns error changeset" do
      equipment_ownership = equipment_ownership_fixture()
      assert {:error, %Ecto.Changeset{}} = EquipmentOwnerships.update_equipment_ownership(equipment_ownership, @invalid_attrs)
      assert equipment_ownership == EquipmentOwnerships.get_equipment_ownership!(equipment_ownership.id)
    end

    test "delete_equipment_ownership/1 deletes the equipment_ownership" do
      equipment_ownership = equipment_ownership_fixture()
      assert {:ok, %EquipmentOwnership{}} = EquipmentOwnerships.delete_equipment_ownership(equipment_ownership)
      assert_raise Ecto.NoResultsError, fn -> EquipmentOwnerships.get_equipment_ownership!(equipment_ownership.id) end
    end

    test "change_equipment_ownership/1 returns a equipment_ownership changeset" do
      equipment_ownership = equipment_ownership_fixture()
      assert %Ecto.Changeset{} = EquipmentOwnerships.change_equipment_ownership(equipment_ownership)
    end
  end
end
