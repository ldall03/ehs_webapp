defmodule EhsWebappWeb.EquipmentSearchLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.{Equipments, EquipmentOwnerships, EquipmentOwnerships.EquipmentOwnership}
  alias EhsWebapp.ClientCompanies

  alias EhsWebapp.Repo

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
    {:ok, 
      socket
      |> assign(form: to_form(%{}),
        ownerships_form: to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{})),
        selection: EquipmentOwnerships.equipment_search_by(nil),
        submit_action: "update",
        equipments: Equipments.list_equipments(),
        client_companies: ClientCompanies.list_client_companies(),
        selected_equipment_name: "",
        selected_brand: "")
      |> stream(:data, [])
      |> allow_upload(:file, accept: ~w(.pdf))
    }
  end

  def handle_event("search", params, socket) do
    data = EquipmentOwnerships.equipment_search(params, socket.assigns.current_user)
      |> Enum.map(fn item -> Map.put(item, :selected, false) end)
    {:noreply, stream(socket, :data, data)}
  end

  def handle_event("clear", _params, socket) do
    selection = EquipmentOwnerships.equipment_search_by(nil)
    {:noreply, 
      socket
      |> stream(:data, [], reset: true)
      |> assign(selection: selection)
    }
  end

  def handle_event("select", params, socket) do
    selection = EquipmentOwnerships.equipment_search_by(params["item_id"])
    deselect = socket.assigns.selection
      |> Map.take([:id, :equipment, :serial_number, :client, :current_owner])
      |> Map.put(:selected, false)
    select = selection
      |> Map.take([:id, :equipment, :serial_number, :client, :current_owner])
      |> Map.put(:selected, true)

    {:noreply, 
      socket
      |> stream(:data, if(deselect.id != "", do: [deselect, select], else: [select]))
      |> assign(selection: selection)
    }
  end

  def handle_event("select_btn_change", params, socket) do
    {:noreply, assign(socket, submit_action: params["select_value"])}
  end

  def handle_event("select_btn_click", params, socket) do
    socket = assign(socket, submit_action: params["value"])
    socket = 
      cond do 
      params["value"] == "update" -> assign(socket,
        selected_brand: socket.assigns.selection.brand, 
        selected_equipment_name: socket.assigns.selection.equipment, 
        ownerships_form: EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
          |> EquipmentOwnerships.change_equipment_ownership()
          |> to_form())
      params["value"] == "create" -> assign(socket,
        selected_brand: "", 
        selected_equipment_name: "",
        ownerships_form: to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{})))
      params["value"] == "delete" -> socket
        |> delete_ownership()
        |> assign(selected_brand: "", 
          selected_equipment_name: "",
          ownerships_form: to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{})))
      end

    {:noreply, socket}
  end

  def handle_event("validate", %{"_target" => ["equipment_input"]} = params, socket) do
    form = EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}, params) 
      |> Ecto.Changeset.put_change(:equipment_id, "")
      |> to_form()
    socket = assign(socket, ownerships_form: form, selected_equipment_name: params["equipment"])
    {:noreply, socket}
  end

  def handle_event("validate", %{"_target" => ["brand_input"]} = params, socket) do
    form = EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}, params) 
      |> Ecto.Changeset.put_change(:equipment_id, "")
      |> to_form()
    socket = assign(socket, ownerships_form: form, selected_brand: params["brand"])
    {:noreply, socket}
  end

  def handle_event("validate", %{"_target" => ["equipment_id_input"], "equipment_id" => id} = params, socket) when id != "" do
    item = socket.assigns.equipments |> Enum.find(fn i -> to_string(i.id) == params["equipment_id"] end)
    params = params
      |> Map.put("brand", item.brand)
      |> Map.put("equipment", item.equipment)
    form = EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}, params) |> to_form()
    socket = assign(socket, ownerships_form: form, selected_equipment_name: item.equipment, selected_brand: item.brand)
    {:noreply, socket}
  end

  def handle_event("validate", %{"_target" => ["equipment_id_input"]} = params, socket) do
    params = params
      |> Map.put("brand", "")
      |> Map.put("equipment", "")
    form = EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}, params) |> to_form()
    socket = assign(socket, ownerships_form: form, selected_equipment_name: "", selected_brand: "")
    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
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

  def handle_event("upload", params, socket) do
    {:noreply, socket}
  end

  defp update_ownership(params, socket) do
    selected = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
    EquipmentOwnerships.update_equipment_ownership(selected, socket.assigns.current_user, params)

    selection = EquipmentOwnerships.equipment_search_by(socket.assigns.selection[:id])
    select = selection
      |> Map.take([:id, :equipment, :serial_number, :client, :current_owner])
      |> Map.put(:selected, true)

    socket
    |> assign(selection: selection)
    |> stream_insert(:data, select)
  end

  defp create_ownership(params, socket) do
    EquipmentOwnerships.create_equipment_ownership(socket.assigns.current_user, params)
    [item] = EquipmentOwnerships.equipment_search(%{"serial_number" => params["serial_number"]}, socket.assigns.current_user)
    stream_insert(socket, :data, Map.put(item, :selected, false))
  end

  defp delete_ownership(socket) do
    selected = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
    select = socket.assigns.selection
      |> Map.take([:id, :equipment, :serial_number, :client, :current_owner])
      |> Map.put(:selected, true)
    EquipmentOwnerships.delete_equipment_ownership(socket.assigns.current_user, selected)

    socket 
    |> assign(selection: EquipmentOwnerships.equipment_search_by(nil))
    |> stream_delete(:data, select)
  end
end
