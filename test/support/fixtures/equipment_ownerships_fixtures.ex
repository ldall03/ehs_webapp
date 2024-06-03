defmodule EhsWebapp.EquipmentOwnershipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EhsWebapp.EquipmentOwnerships` context.
  """

  @doc """
  Generate a equipment_ownership.
  """
  def equipment_ownership_fixture(attrs \\ %{}) do
    {:ok, equipment_ownership} =
      attrs
      |> Enum.into(%{
        batch_number: 42,
        current_owner: "some current_owner",
        delivery_date: ~D[2024-06-02],
        department: "some department",
        inactive_date: ~D[2024-06-02],
        inspection_interval: 42,
        last_inspection_date: ~D[2024-06-02],
        mfgdt: "some mfgdt",
        next_inspection_date: ~D[2024-06-02],
        owner_id: "some owner_id",
        serial_number: "some serial_number",
        service_date: ~D[2024-06-02],
        shelf_date: ~D[2024-06-02]
      })
      |> EhsWebapp.EquipmentOwnerships.create_equipment_ownership()

    equipment_ownership
  end
end
