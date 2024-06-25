defmodule EhsWebapp.Repo.Migrations.AddUserCol do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :permissions, :integer
      add :f_name, :string
      add :l_name, :string
      add :client_company_id, references(:client_companies, on_delete: :delete_all)
    end
    create index(:users, [:client_company_id])
  end
end
