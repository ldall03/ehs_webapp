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
    field :equipment_id, :id
    field :client_company_id, :id

    timestamps()
  end

  @doc false
  def changeset(equipment_ownership, attrs) do
    equipment_ownership
    |> cast(attrs, [:serial_number, :batch_number, :mfgdt, :shelf_date, :inspection_interval, :delivery_date, :service_date, :last_inspection_date, :next_inspection_date, :department, :current_owner, :owner_id, :inactive_date])
    |> validate_required([:serial_number, :batch_number, :mfgdt, :shelf_date, :inspection_interval, :delivery_date, :service_date, :last_inspection_date, :next_inspection_date, :department, :current_owner, :owner_id, :inactive_date])
  end
end
