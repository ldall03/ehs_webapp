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

  describe "calibrations" do
    alias EhsWebapp.EquipmentOwnerships.Calibration

    import EhsWebapp.EquipmentOwnershipsFixtures

    @invalid_attrs %{url: nil}

    test "list_calibrations/0 returns all calibrations" do
      calibration = calibration_fixture()
      assert EquipmentOwnerships.list_calibrations() == [calibration]
    end

    test "get_calibration!/1 returns the calibration with given id" do
      calibration = calibration_fixture()
      assert EquipmentOwnerships.get_calibration!(calibration.id) == calibration
    end

    test "create_calibration/1 with valid data creates a calibration" do
      valid_attrs = %{url: "some url"}

      assert {:ok, %Calibration{} = calibration} = EquipmentOwnerships.create_calibration(valid_attrs)
      assert calibration.url == "some url"
    end

    test "create_calibration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EquipmentOwnerships.create_calibration(@invalid_attrs)
    end

    test "update_calibration/2 with valid data updates the calibration" do
      calibration = calibration_fixture()
      update_attrs = %{url: "some updated url"}

      assert {:ok, %Calibration{} = calibration} = EquipmentOwnerships.update_calibration(calibration, update_attrs)
      assert calibration.url == "some updated url"
    end

    test "update_calibration/2 with invalid data returns error changeset" do
      calibration = calibration_fixture()
      assert {:error, %Ecto.Changeset{}} = EquipmentOwnerships.update_calibration(calibration, @invalid_attrs)
      assert calibration == EquipmentOwnerships.get_calibration!(calibration.id)
    end

    test "delete_calibration/1 deletes the calibration" do
      calibration = calibration_fixture()
      assert {:ok, %Calibration{}} = EquipmentOwnerships.delete_calibration(calibration)
      assert_raise Ecto.NoResultsError, fn -> EquipmentOwnerships.get_calibration!(calibration.id) end
    end

    test "change_calibration/1 returns a calibration changeset" do
      calibration = calibration_fixture()
      assert %Ecto.Changeset{} = EquipmentOwnerships.change_calibration(calibration)
    end
  end

  describe "technical_reports" do
    alias EhsWebapp.EquipmentOwnerships.TechnicalReport

    import EhsWebapp.EquipmentOwnershipsFixtures

    @invalid_attrs %{url: nil}

    test "list_technical_reports/0 returns all technical_reports" do
      technical_report = technical_report_fixture()
      assert EquipmentOwnerships.list_technical_reports() == [technical_report]
    end

    test "get_technical_report!/1 returns the technical_report with given id" do
      technical_report = technical_report_fixture()
      assert EquipmentOwnerships.get_technical_report!(technical_report.id) == technical_report
    end

    test "create_technical_report/1 with valid data creates a technical_report" do
      valid_attrs = %{url: "some url"}

      assert {:ok, %TechnicalReport{} = technical_report} = EquipmentOwnerships.create_technical_report(valid_attrs)
      assert technical_report.url == "some url"
    end

    test "create_technical_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EquipmentOwnerships.create_technical_report(@invalid_attrs)
    end

    test "update_technical_report/2 with valid data updates the technical_report" do
      technical_report = technical_report_fixture()
      update_attrs = %{url: "some updated url"}

      assert {:ok, %TechnicalReport{} = technical_report} = EquipmentOwnerships.update_technical_report(technical_report, update_attrs)
      assert technical_report.url == "some updated url"
    end

    test "update_technical_report/2 with invalid data returns error changeset" do
      technical_report = technical_report_fixture()
      assert {:error, %Ecto.Changeset{}} = EquipmentOwnerships.update_technical_report(technical_report, @invalid_attrs)
      assert technical_report == EquipmentOwnerships.get_technical_report!(technical_report.id)
    end

    test "delete_technical_report/1 deletes the technical_report" do
      technical_report = technical_report_fixture()
      assert {:ok, %TechnicalReport{}} = EquipmentOwnerships.delete_technical_report(technical_report)
      assert_raise Ecto.NoResultsError, fn -> EquipmentOwnerships.get_technical_report!(technical_report.id) end
    end

    test "change_technical_report/1 returns a technical_report changeset" do
      technical_report = technical_report_fixture()
      assert %Ecto.Changeset{} = EquipmentOwnerships.change_technical_report(technical_report)
    end
  end
end
