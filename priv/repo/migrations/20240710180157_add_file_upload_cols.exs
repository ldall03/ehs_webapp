defmodule EhsWebapp.Repo.Migrations.AddFileUploadCols do
  use Ecto.Migration

  def change do
    alter table("equipments") do
      add :manual_url, :string
      add :brochure_url, :string
      add :spec_sheet_url, :string
      add :certificate_url, :string
    end
  end
end
