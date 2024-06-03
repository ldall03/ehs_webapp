defmodule EhsWebapp.Equipments.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :category, :string
    has_many :subcategories, EhsWebapp.Equipments.Subcategory

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:category])
    |> validate_required([:category])
  end
end
