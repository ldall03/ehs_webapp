defmodule EhsWebapp.EquipmentOwnerships.Calibration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calibrations" do
    field :display_name, :string
    field :url, :string
    belongs_to :equipment_ownership, EhsWebapp.EquipmentOwnerships.EquipmentOwnership

    timestamps()
  end

  @doc false
  def changeset(calibration, attrs) do
    calibration
    |> cast(attrs, [:display_name, :url, :equipment_ownership_id])
    |> validate_required([:display_name, :url, :equipment_ownership_id])
  end
end
