defmodule EhsWebappWeb.EquipmentSearchLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.{Equipments, EquipmentOwnerships}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, 
      data: [],
      selection: EquipmentOwnerships.equipment_search_by(nil),
      form: to_form(%{}))
    }
  end

  def handle_event("search", params, socket) do
    data = EquipmentOwnerships.equipment_search(params, socket.assigns.data)
    socket = assign(socket,
      data: data
    )
    {:noreply, socket}
  end

  def handle_event("clear", _params, socket) do
    data = []
    selection = EquipmentOwnerships.equipment_search_by(nil)
    socket = assign(socket,
      data: data,
      selection: selection
    )
    {:noreply, socket}
  end

  def handle_event("select", params, socket) do
    selection = EquipmentOwnerships.equipment_search_by(params["item_id"])
    socket = assign(socket,
      selection: selection
    )
    {:noreply, socket}
  end
end
