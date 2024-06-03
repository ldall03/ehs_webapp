defmodule EhsWebapp.Repo.Migrations.CreateEquipments do
  use Ecto.Migration

  def change do
    create table(:equipments) do
      add :brand, :text
      add :description, :text
      add :subcategory_id, references(:subcategories, on_delete: :delete_all)

      timestamps()
    end

    create index(:equipments, [:subcategory_id])
  end
end
