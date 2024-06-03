defmodule EhsWebapp.Equipments.Subcategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subcategories" do
    field :subcategory, :string
    belongs_to :category, EhsWebapp.Equipments.Category
    has_many :equipments, EhsWebapp.Equipments.Equipment

    timestamps()
  end

  @doc false
  def changeset(subcategory, attrs) do
    subcategory
    |> cast(attrs, [:subcategory, :category_id])
    |> validate_required([:subcategory, :subcategory_id])
  end
end
