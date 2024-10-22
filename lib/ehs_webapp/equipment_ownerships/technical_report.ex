defmodule EhsWebapp.EquipmentOwnerships.TechnicalReport do
  use Ecto.Schema
  import Ecto.Changeset

  schema "technical_reports" do
    field :display_name, :string
    field :url, :string
    belongs_to :equipment_ownership, EhsWebapp.EquipmentOwnerships.EquipmentOwnership

    timestamps()
  end

  @doc false
  def changeset(technical_report, attrs) do
    technical_report
    |> cast(attrs, [:display_name, :url, :equipment_ownership_id])
    |> validate_required([:display_name, :url, :equipment_ownership_id])
  end
end
