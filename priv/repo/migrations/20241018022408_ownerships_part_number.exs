defmodule EhsWebapp.Repo.Migrations.OwnershipsPartNumber do
  use Ecto.Migration

  def change do
    alter table(:equipment_ownerships) do
      add :part_number, :string
    end

    create unique_index(:equipment_ownerships, [:part_number])
  end
end
