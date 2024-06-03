defmodule EhsWebapp.Repo.Migrations.CreateSubcategories do
  use Ecto.Migration

  def change do
    create table(:subcategories) do
      add :subcategory, :text
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps()
    end

    create index(:subcategories, [:category_id])
  end
end
