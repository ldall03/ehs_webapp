defmodule EhsWebapp.Repo.Migrations.CreateTechnicalReports do
  use Ecto.Migration

  def change do
    create table(:technical_reports) do
      add :url, :string
      add :equipment_ownership_id, references(:equipment_ownerships, on_delete: :delete_all)

      timestamps()
    end

    create index(:technical_reports, [:equipment_ownership_id])
  end
end
