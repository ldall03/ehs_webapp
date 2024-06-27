defmodule EhsWebappWeb.EquipmentSearchLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.{Equipments, EquipmentOwnerships, EquipmentOwnerships.EquipmentOwnership}

  def toggle_form_admin(js \\ %JS{}, exec \\ true) do
    if exec do 
      js
      |> JS.toggle(to: ".toggleable")
      |> JS.toggle(to: ".toggleable-noadmin")
      |> JS.toggle(to: "#info-form-select-btn")
      |> JS.toggle(to: "#confirm-button")
      |> JS.toggle(to: "#cancel-button")
    else
      js
    end
  end

  def toggle_form_noadmin(js \\ %JS{}) do
    js
    |> JS.toggle(to: ".toggleable-noadmin")
    |> JS.toggle(to: "#info-form-btn")
    |> JS.toggle(to: "#confirm-button")
    |> JS.toggle(to: "#cancel-button")
  end

  def toggle_forms(js \\ %JS{}, user) do
    if user.superuser do
      js |> toggle_form_admin()
    else
      js |> toggle_form_noadmin()
    end  
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, 
      data: [],
      selection: EquipmentOwnerships.equipment_search_by(nil),
      submit_action: "update",
      form: to_form(%{}),
      ownerships_form: to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}))
    )}
  end

  def handle_event("search", params, socket) do
    data = EquipmentOwnerships.equipment_search(params, socket.assigns.current_user, socket.assigns.data)
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
      selection: selection,
    )
    {:noreply, socket}
  end

  def handle_event("select_btn_click", params, socket) do
    ownerships_form = cond do
      socket.assigns.submit_action == "update" -> 
        ownership = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
        to_form(EquipmentOwnerships.change_equipment_ownership(ownership))
      true -> to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}))
    end

    socket = if params["value"] == "delete", do: delete_ownership(socket), else: socket
    socket = assign(socket, ownerships_form: ownerships_form)
    {:noreply, socket}
  end

  def handle_event("select_btn_change", params, socket) do
    socket = assign(socket, submit_action: params["select_value"])
    {:noreply, socket}
  end

  def handle_event("ownership_submit", params, socket) do
    socket = case socket.assigns.submit_action do
      "update"  -> update_ownership(params, socket)
      "create"  -> create_ownership(params, socket)
      _         -> socket
    end

    {:noreply, socket}
  end

  defp update_ownership(params, socket) do
    selected = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
    EquipmentOwnerships.update_equipment_ownership(selected, socket.assigns.current_user, params)
    selection = EquipmentOwnerships.equipment_search_by(socket.assigns.selection[:id])
    data = EquipmentOwnerships.equipment_search(%{}, socket.assigns.current_user, socket.assigns.data)
    assign(socket, data: data, selection: selection)
  end

  defp create_ownership(params, socket) do
    EquipmentOwnerships.create_equipment_ownership(socket.assigns.current_user, params)
    data = EquipmentOwnerships.equipment_search(%{"serial_number" => params["serial_number"]}, socket.assigns.current_user, socket.assigns.data)
    assign(socket, data: data)
  end

  defp delete_ownership(socket) do
    selected = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
    EquipmentOwnerships.delete_equipment_ownership(socket.assigns.current_user, selected)
    selection = EquipmentOwnerships.equipment_search_by(nil)
    data = EquipmentOwnerships.equipment_search(%{}, socket.assigns.current_user, socket.assigns.data)
    assign(socket, data: data, selection: selection)
  end
end
