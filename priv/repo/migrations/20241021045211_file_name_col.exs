defmodule EhsWebapp.Repo.Migrations.FileNameCol do
  use Ecto.Migration

  def change do
    alter table(:calibrations) do
      add :display_name, :string
    end

    alter table(:technical_reports) do
      add :display_name, :string
    end
  end
end
