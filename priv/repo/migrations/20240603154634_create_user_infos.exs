defmodule EhsWebapp.Repo.Migrations.CreateUserInfos do
  use Ecto.Migration

  def change do
    create table(:user_infos) do
      add :f_name, :text
      add :l_name, :text
      add :permissions, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :client_company_id, references(:client_companies, on_delete: :delete_all)

      timestamps()
    end

    create index(:user_infos, [:user_id])
    create index(:user_infos, [:client_company_id])
  end
end
