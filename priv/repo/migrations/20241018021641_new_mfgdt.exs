defmodule EhsWebapp.Repo.Migrations.NewMfgdt do
  use Ecto.Migration

  def change do
    alter table(:equipment_ownerships) do
      add :mfgdt, :date
    end
  end
end
