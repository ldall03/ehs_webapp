defmodule EhsWebapp.EquipmentOwnerships.EquipmentOwnership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipment_ownerships" do
    field :serial_number, :string
    field :part_number, :string
    field :batch_number, :integer
    field :mfgdt, :date
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
    field :status, :string
    field :comments, :string
    belongs_to :equipment, EhsWebapp.Equipments.Equipment
    belongs_to :client_company, EhsWebapp.ClientCompanies.ClientCompany
    has_many :calibrations, EhsWebapp.EquipmentOwnerships.Calibration
    has_many :technical_reports, EhsWebapp.EquipmentOwnerships.TechnicalReport

    timestamps()
  end

  @doc false
  def changeset(equipment_ownership, attrs) do
    equipment_ownership
    |> cast(attrs, [:serial_number, :part_number, :batch_number, :mfgdt, :shelf_date, :inspection_interval, :delivery_date, :service_date, :last_inspection_date, :next_inspection_date, :department, :current_owner, :owner_id, :inactive_date, :equipment_id, :client_company_id, :status, :comments])
    |> validate_required([:serial_number, :part_number, :equipment_id, :client_company_id])
    |> unique_constraint(:part_number)
    |> unique_constraint(:serial_number)
  end
end
