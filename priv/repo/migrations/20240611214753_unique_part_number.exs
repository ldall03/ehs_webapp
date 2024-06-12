defmodule EhsWebapp.Repo.Migrations.UniquePartNumber do
  use Ecto.Migration

  def change do
    alter table(:equipments) do
      add :part_number, :string
    end

    create unique_index(:equipments, [:part_number])
  end
end
