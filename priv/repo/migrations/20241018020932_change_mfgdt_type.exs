defmodule EhsWebapp.Repo.Migrations.ChangeMfgdtType do
  use Ecto.Migration

  def change do
    alter table(:equipment_ownerships) do
      remove :mfgdt
    end
  end
end
