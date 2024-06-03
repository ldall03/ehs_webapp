defmodule EhsWebapp.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :category, :text

      timestamps()
    end
  end
end
