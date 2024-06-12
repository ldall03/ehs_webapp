defmodule EhsWebapp.Equipments.Equipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipments" do
    field :part_number, :string
    field :equipment, :string
    field :description, :string
    field :brand, :string
    belongs_to :subcategory, EhsWebapp.Equipments.Subcategory
    has_many :equipment_ownerships, EhsWebapp.EquipmentOwnerships.EquipmentOwnership

    timestamps()
  end

  @doc false
  def changeset(equipment, attrs) do
    equipment
    |> cast(attrs, [:equipment, :brand, :description, :subcategory_id])
    |> validate_required([:equipment, :brand, :subcategory_id])
    |> unique_constraint(:part_number)
  end
end
