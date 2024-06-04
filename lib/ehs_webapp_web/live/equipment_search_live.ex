defmodule EhsWebappWeb.EquipmentSearchLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.Equipments

  def mount(_params, _session, socket) do
    {:ok, assign(socket, 
      categories: Equipments.list_categories(),
      subcategories: [],
      form: to_form(%{}))
    }
  end
end
