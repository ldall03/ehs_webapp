defmodule EhsWebapp.Repo.Migrations.CreateEquipmentOwnerships do
  use Ecto.Migration

  def change do
    create table(:equipment_ownerships) do
      add :serial_number, :text
      add :batch_number, :integer
      add :mfgdt, :text
      add :shelf_date, :date
      add :inspection_interval, :integer
      add :delivery_date, :date
      add :service_date, :date
      add :last_inspection_date, :date
      add :next_inspection_date, :date
      add :department, :text
      add :current_owner, :text
      add :owner_id, :text
      add :inactive_date, :date
      add :equipment_id, references(:equipments, on_delete: :delete_all)
      add :client_company_id, references(:client_companies, on_delete: :delete_all)

      timestamps()
    end

    create index(:equipment_ownerships, [:equipment_id])
    create index(:equipment_ownerships, [:client_company_id])
  end
end
