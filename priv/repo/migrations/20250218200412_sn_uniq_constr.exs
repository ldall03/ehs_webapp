defmodule EhsWebapp.Repo.Migrations.SnUniqConstr do
  use Ecto.Migration

  def change do
    create unique_index(:equipment_ownerships, [:serial_number])
  end
end
