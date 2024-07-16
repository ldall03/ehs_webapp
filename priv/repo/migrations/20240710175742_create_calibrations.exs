defmodule EhsWebapp.Repo.Migrations.CreateCalibrations do
  use Ecto.Migration

  def change do
    create table(:calibrations) do
      add :url, :string
      add :equipment_ownership_id, references(:equipment_ownerships, on_delete: :delete_all)

      timestamps()
    end

    create index(:calibrations, [:equipment_ownership_id])
  end
end
