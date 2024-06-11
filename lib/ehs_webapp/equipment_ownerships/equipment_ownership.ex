defmodule EhsWebapp.EquipmentOwnerships.EquipmentOwnership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipment_ownerships" do
    field :serial_number, :string
    field :batch_number, :integer
    field :mfgdt, :string
    field :shelf_date, :date
    field :inspection_interval, :integer
    field :delivery_date, :date
    field :service_date, :date
    field :last_inspection_date, :date
    field :next_inspection_date, :date
    field :department, :string
    field :current_owner, :string
    field :owner_id, :string
    field :inactive_date, :date
    belongs_to :equipment, EhsWebapp.Equipments.Equipment
    belongs_to :client_company, EhsWebapp.ClientCompanies.ClientCompany

    timestamps()
  end

  @doc false
  def changeset(equipment_ownership, attrs) do
    equipment_ownership
    |> cast(attrs, [:serial_number, :batch_number, :mfgdt, :shelf_date, :inspection_interval, :delivery_date, :service_date, :last_inspection_date, :next_inspection_date, :department, :current_owner, :owner_id, :inactive_date, :equipment_id, :client_company_id])
    |> validate_required([:serial_number, :batch_number, :mfgdt, :equipment_id, :client_company_id])
  end
end
