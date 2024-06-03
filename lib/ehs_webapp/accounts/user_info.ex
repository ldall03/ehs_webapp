defmodule EhsWebapp.Accounts.UserInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_infos" do
    field :permissions, :integer
    field :f_name, :string
    field :l_name, :string
    field :user_id, :id
    field :client_company_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_info, attrs) do
    user_info
    |> cast(attrs, [:f_name, :l_name, :permissions])
    |> validate_required([:f_name, :l_name, :permissions])
  end
end
