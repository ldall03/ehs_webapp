defmodule EhsWebappWeb.EquipmentSearchLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.Equipments

  def mount(_params, _session, socket) do
    {:ok, assign(socket, 
      categories: Equipments.list_categories(),
      subcategories: [],
      data: [],
      disabled: true,
      form: to_form(%{}))
    }
  end

  def handle_event("cat_change", %{"_target" => _t, "category" => "-"}, socket) do
    socket = assign(socket, 
      subcategories: [],
      disabled: true
    )
    {:noreply, socket}
  end

  def handle_event("cat_change", %{"_target" => _t, "category" => id}, socket) do
    subcategories = Equipments.list_subcategories(String.to_integer(id))
    socket = assign(socket, 
      subcategories: subcategories,
      disabled: false
    )
    {:noreply, socket}
  end

  def handle_event("search", params, socket) do
    data = []
    socket = assign(socket,
      data: data
    )
    {:noreply, socket}
  end
end
