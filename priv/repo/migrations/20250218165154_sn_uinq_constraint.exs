defmodule EhsWebapp.Repo.Migrations.SnUinqConstraint do
  use Ecto.Migration

  def change do
    drop index(:equipment_ownerships, [:part_number])
  end
end
