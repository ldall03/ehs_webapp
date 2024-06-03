defmodule EhsWebapp.Equipments.Equipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipments" do
    field :description, :string
    field :brand, :string
    belongs_to :subcategory, EhsWebapp.Equipments.Subcategory

    timestamps()
  end

  @doc false
  def changeset(equipment, attrs) do
    equipment
    |> cast(attrs, [:brand, :description, :subcategory_id])
    |> validate_required([:brand, :description, :subcategory_id])
  end
end
