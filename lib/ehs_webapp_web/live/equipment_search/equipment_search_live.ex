defmodule EhsWebappWeb.EquipmentSearchLive do
  use EhsWebappWeb, :live_view

  alias EhsWebapp.{EquipmentOwnerships.EquipmentOwnership, EquipmentOwnerships.Calibration, EquipmentOwnerships.TechnicalReport}
  alias EhsWebapp.Equipments
  alias EhsWebapp.EquipmentOwnerships
  alias EhsWebapp.ClientCompanies

  alias EhsWebapp.SimpleS3Upload

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
    if user.admin do
      js |> toggle_form_admin()
    else
      js |> toggle_form_noadmin()
    end  
  end

  def toggle_file_upload(js \\ %JS{}) do
    js
    |> JS.toggle_class("overflow-hidden", to: "body")
    |> JS.toggle(to: "#file-upload-backdrop")
    |> JS.toggle(to: "#file-upload-container")
  end
  
  def clear_inputs(js \\ %JS{}) do
    js
    |> JS.set_attribute({"value", ""}, to: ".search_input")
  end

  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(search_form: to_form(%{"empty" => nil}),
        ownerships_form: to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{})),
        data: [],
        show_overdue: false,
        order_by_name: false,
        selection: EquipmentOwnerships.equipment_search_by(nil),
        submit_action: "update",
        next_inspection_date_changed: false,
        equipments: Equipments.list_equipments(),
        client_companies: ClientCompanies.list_client_companies(),
        selected_brand: "",
        file_prefix: "")
      |> stream(:data, [])
      |> stream(:calibrations, [])
      |> stream(:tech_reports, [])
      |> allow_upload(:files, accept: ~w(.pdf), max_file_size: 5_000_000, auto_upload: true, external: &presign_upload/2)
    }
  end

  def handle_event("search", params, socket) do
    data = EquipmentOwnerships.equipment_search(params, socket.assigns.current_user) 
      |> Enum.map(fn item -> Map.put(item, :selected, false) end)
    data = socket.assigns.data ++ data
      |> Enum.uniq_by(&(&1.id))
      |> Enum.map(&(Map.replace(&1, :selected, &1.id == socket.assigns.selection.id)))

    ordered_data = 
      if socket.assigns.order_by_name do
        Enum.sort(data, fn a, b -> String.downcase(a.equipment) <= String.downcase(b.equipment) end)
      else
        data 
      end

    stream_data = 
      if socket.assigns.show_overdue do 
        Enum.filter(ordered_data, fn item -> item.next_inspection_date && Date.compare(Date.utc_today(), item.next_inspection_date) == :gt end) 
      else 
        ordered_data 
      end

    send_update(EhsWebappWeb.CategorySelectComponent, id: "category_select", parent_form: to_form(%{})) # clear category_select

    case stream_data do
      [] -> {:noreply, 
              socket
              |> put_flash(:error, "Search result came back empty.")
              |> assign(search_form: to_form(%{}))
            }
      _  -> {:noreply, 
              socket
              |> stream(:data, stream_data, reset: true)
              |> assign(search_form: to_form(%{}), data: data)
            }
    end
  end

  def handle_event("search_change", params, socket) do
    {:noreply, assign(socket, search_form: to_form(params))}
  end

  def handle_event("showall", _params, socket) do
    data = EquipmentOwnerships.equipment_search(%{}, socket.assigns.current_user) 
      |> Enum.map(fn item -> Map.put(item, :selected, false) end)

    stream_data = 
      if socket.assigns.show_overdue do 
        Enum.filter(data, fn item -> item.next_inspection_date && Date.compare(Date.utc_today(), item.next_inspection_date) == :gt end) 
      else 
        data 
      end

    send_update(EhsWebappWeb.CategorySelectComponent, id: "category_select", parent_form: to_form(%{})) # clear category_select

    {:noreply, 
      socket
      |> stream(:data, stream_data, reset: true)
      |> assign(search_form: to_form(%{}), data: data)
    }
  end

  def handle_event("toggle_order_by_name", _params, socket) do
    ordered_data = 
      if socket.assigns.order_by_name do
        socket.assigns.data 
      else
        Enum.sort(socket.assigns.data, fn a, b -> String.downcase(a.equipment) <= String.downcase(b.equipment) end)
      end
    
    {:noreply, 
      socket
      |> assign(:order_by_name, not socket.assigns.order_by_name)
      |> stream(:data, ordered_data, reset: true)
    }
  end

  def handle_event("toggle_show_overdue", _params, socket) do
    stream_data = 
      if socket.assigns.show_overdue do 
        socket.assigns.data 
      else 
        Enum.filter(socket.assigns.data, fn item -> item.next_inspection_date && Date.compare(Date.utc_today(), item.next_inspection_date) == :gt end) 
      end

    {:noreply, 
      socket
      |> assign(:show_overdue, not socket.assigns.show_overdue)
      |> stream(:data, stream_data, reset: true)
    }
  end

  def handle_event("clear", _params, socket) do
    selection = EquipmentOwnerships.equipment_search_by(nil)

    send_update(EhsWebappWeb.CategorySelectComponent, id: "category_select", parent_form: to_form(%{})) # clear category_select

    {:noreply, 
      socket
      |> stream(:data, [], reset: true)
      |> stream(:calibrations, [], reset: true)
      |> stream(:tech_reports, [], reset: true)
      |> assign(selection: selection, search_form: to_form(%{}))
      |> assign(data: [])
    }
  end

  def handle_event("select", params, socket) do
    if params["item_id"] == to_string(socket.assigns.selection.id) do
      {:noreply, socket}
    else
      selection = EquipmentOwnerships.equipment_search_by(params["item_id"])
      deselect = socket.assigns.selection
        |> Map.take([:id, :equipment, :serial_number, :client, :current_owner, :department, :next_inspection_date])
        |> Map.put(:selected, false)
      select = selection
        |> Map.take([:id, :equipment, :serial_number, :client, :current_owner, :department, :next_inspection_date])
        |> Map.put(:selected, true)

      data = Enum.map(socket.assigns.data, &(Map.replace(&1, :selected, &1.id == select.id)))
      ordered_data = 
        if socket.assigns.order_by_name do
          Enum.sort(data, fn a, b -> String.downcase(a.equipment) <= String.downcase(b.equipment) end)
        else
          data 
        end
      stream_data = 
        if socket.assigns.show_overdue do 
          Enum.filter(ordered_data, fn item -> item.next_inspection_date && Date.compare(Date.utc_today(), item.next_inspection_date) == :gt end) 
        else 
          ordered_data 
        end

      {:noreply, 
        socket
        |> stream(:calibrations, EquipmentOwnerships.list_calibrations_by(selection.id), reset: true)
        |> stream(:tech_reports, EquipmentOwnerships.list_technical_reports_by(selection.id), reset: true)
        |> stream(:data, stream_data, reset: true)
        |> assign(selection: selection)
        |> assign(data: data)
      }
    end
  end

  def handle_event("select_btn_change", params, socket) do
    {:noreply, assign(socket, submit_action: params["select_value"])}
  end

  def handle_event("select_btn_click", params, socket) do
    socket = 
      cond do 
      params["value"] == "update" -> assign(socket,
        selected_brand: socket.assigns.selection.brand, 
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
        true -> socket
      end

    {:noreply, assign(socket, next_inspection_date_changed: false)}
  end

  def handle_event("validate", %{"_target" => ["equipment_id_input"], "equipment_id" => ""} = params, socket) do
    form = EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}, params) |> to_form()
    socket = assign(socket, ownerships_form: form, selected_brand: "")
    {:noreply, socket}
  end

  def handle_event("validate", %{"_target" => ["equipment_id_input"], "equipment_id" => id} = params, socket) do
    item = socket.assigns.equipments |> Enum.find(fn i -> to_string(i.id) == params["equipment_id"] end)
    params = params |> Map.put("brand", item.brand)

    form = EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}, params) |> to_form()
    socket = assign(socket, ownerships_form: form, selected_brand: item.brand)
    {:noreply, socket}
  end

  def handle_event("validate", %{"_target" => ["next_inspection_date"]} = params, socket) do
    {:noreply, assign(socket, next_inspection_date_changed: true)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("ownership_submit", params, socket) do
    socket = case socket.assigns.submit_action do
      "update"  -> update_ownership(Map.put(params, "next_inspection_date_changed", socket.assigns.next_inspection_date_changed), socket)
      "create"  -> create_ownership(Map.put(params, "next_inspection_date_changed", socket.assigns.next_inspection_date_changed), socket)
      _         -> socket
    end

    {:noreply, socket}
  end

  def handle_event("choose_file_prefix", params, socket) do
    {:noreply, assign(socket, file_prefix: params["value"])} 
  end

  def handle_event("upload_validate", params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload", %{"file_prefix" => "calibration"}, socket) do
    params = %{
      "display_name"            => get_file_name(socket, "cal"),
      "equipment_ownership_id"  => socket.assigns.selection.id,
      "url" => nil
    }

    params = put_file_url(socket, params)

    case EquipmentOwnerships.create_calibration(socket.assigns.current_user, params) do
      {:ok, _} ->
        {:noreply, socket 
          |> stream(:calibrations, EquipmentOwnerships.list_calibrations_by(socket.assigns.selection.id), at: 0)
          |> put_flash(:info, "Calibration file uploaded.")
        }
      {:error, :unauthorized} -> {:noreply, :error, "You are not authorized to upload files for this equipment."}
      _                       -> {:noreply, put_flash(socket, :error, "Something went wrong")}
    end
  end

  def handle_event("upload", %{"file_prefix" => "report"}, socket) do
    params = %{
      "display_name"            => get_file_name(socket, "rep"),
      "equipment_ownership_id"  => socket.assigns.selection.id,
      "url" => nil
    }

    params = put_file_url(socket, params)

    case EquipmentOwnerships.create_technical_report(socket.assigns.current_user, params) do
      {:ok, _} ->
        {:noreply, socket 
          |> stream(:tech_reports, EquipmentOwnerships.list_technical_reports_by(socket.assigns.selection.id), at: 0)
          |> put_flash(:info, "Maintenance Report file uploaded.")
        }
      {:error, :unauthorized} -> {:noreply, :error, "You are not authorized to upload files for this equipment."}
      _                       -> {:noreply, put_flash(socket, :error, "Something went wrong")}
    end
  end

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :files, ref)}
  end

  def handle_event("cancel_upload", _params, socket) do
    {:noreply, socket}
  end

  defp update_ownership(params, socket) do
    selected = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
    {status, changeset} = EquipmentOwnerships.update_equipment_ownership(selected, socket.assigns.current_user, params)

    selection = EquipmentOwnerships.equipment_search_by(socket.assigns.selection[:id])
    select = selection
      |> Map.take([:id, :equipment, :serial_number, :client, :current_owner, :next_inspection_date])
      |> Map.put(:selected, true)

    case status do 
      :error  -> Map.to_list(Ecto.Changeset.traverse_errors(changeset, fn {msg, opt} -> msg end))
        |> Enum.reduce(socket, fn {field, [msg | rest]}, acc -> put_flash(acc, :error, to_string(field) <> " " <> msg) end)
      _       -> socket
        |> assign(selection: selection)
        |> assign(data: Enum.map(socket.assigns.data, &(if &1.id == select.id do select else &1 end)))
        |> stream_insert(:data, select)
    end
  end

  defp create_ownership(params, socket) do # TODO: refactor using return of create_equipment_ownership
    {status, changeset} = EquipmentOwnerships.create_equipment_ownership(socket.assigns.current_user, params)
    [item] = EquipmentOwnerships.equipment_search(%{"serial_number" => params["serial_number"]}, socket.assigns.current_user)

    case status do
      :error  -> Map.to_list(Ecto.Changeset.traverse_errors(changeset, fn {msg, opt} -> msg end))
        |> Enum.reduce(socket, fn {field, [msg | rest]}, acc -> put_flash(acc, :error, to_string(field) <> " " <> msg) end)
      _       -> socket
        |> assign(data: socket.assigns.data ++ [Map.put(item, :selected, false)])
        |> stream_insert(:data, Map.put(item, :selected, false))
    end
  end

  defp delete_ownership(socket) do
    selected = EquipmentOwnerships.get_equipment_ownership!(socket.assigns.selection[:id])
    select = socket.assigns.selection
      |> Map.take([:id, :equipment, :serial_number, :client, :current_owner, :next_inspection_date])
      |> Map.put(:selected, true)
    case EquipmentOwnerships.delete_equipment_ownership(socket.assigns.current_user, selected) do
      {:ok, ownership} -> socket 
        |> assign(selection: EquipmentOwnerships.equipment_search_by(nil))
        |> assign(data: Enum.filter(socket.assigns.data, &(&1.id != select.id)))
        |> stream_delete(:data, select)
      {:error, :unauthorized} -> socket |> put_flash(:error, "You do not have the permission to perform this action")
    end
  end

  defp error_to_string(:too_large), do: "File is too large"
  defp error_to_string(:not_accepted), do: "Only .pdf files are allowed"
  defp error_to_string(:too_many_files), do: "You may only choose one file"
  defp error_to_string(error), do: "[ERROR]: #{Atom.to_string(error)}"
  defp format_file_size(size) do
    if size > 1_000_000 do
      "#{Float.round(size / 1_000_000, 2)} Mb"
    else
      "#{Float.round(size / 1000, 1)} Kb"
    end
  end

  defp get_file_name(socket, prefix) do
    String.upcase(prefix) <> "_"
    <> (socket.assigns.selection.client 
    |> String.slice(0..2)
    |> String.upcase())
    <> (to_string(DateTime.utc_now(:second))
    |> String.replace("-", "")
    |> String.replace(":", "")
    |> String.replace(" ", "T")
    |> String.replace("Z", "U"))
    <> to_string(socket.assigns.current_user.id)
    <> ".pdf"
  end

  defp put_file_url(socket, params) do
    uploaded_file_urls = consume_uploaded_entries(socket, :files, fn meta, entry ->
      {:ok, SimpleS3Upload.entry_url(entry)}
    end)

    %{params | "url" => List.first(uploaded_file_urls)}
  end

  defp presign_upload(entry, %{assigns: %{uploads: uploads}} = socket) do
    {:ok, SimpleS3Upload.meta(entry, uploads), socket}
  end
end
