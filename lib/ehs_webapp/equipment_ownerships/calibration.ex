defmodule EhsWebapp.EquipmentOwnerships.Calibration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calibrations" do
    field :url, :string
    belongs_to :equipment_ownership, EhsWebapp.EquipmentOwnerships.EquipmentOwnership

    timestamps()
  end

  @doc false
  def changeset(calibration, attrs) do
    calibration
    |> cast(attrs, [:url, :equipment_ownership_id])
    |> validate_required([:url, :equipment_ownership_id])
  end
end
