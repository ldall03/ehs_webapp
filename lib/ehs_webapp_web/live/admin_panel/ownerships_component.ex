
defmodule EhsWebappWeb.AdminPanelLive.OwnershipsComponent do
  use EhsWebappWeb, :live_component
  
  alias EhsWebapp.{EquipmentOwnerships, EquipmentOwnerships.EquipmentOwnership}

  def mount(socket) do
    socket = assign(socket, 
      form: to_form(EquipmentOwnerships.change_equipment_ownership(%EquipmentOwnership{}))
    )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Ownerships</div>
      <.form for={@form} phx-submit="new_ownership" phx-target={@myself}>
        <.input type="text" label="Equipment ID*" name="equipment_id" placeholder="Equipment id" value="" autocomplete="off" field={@form[:equipment_id]}/>
        <.input type="text" label="Serial Number*" name="serial_number" placeholder="Serial Number" value="" autocomplete="off" field={@form[:serial_number]}/>
        <.input type="text" label="Batch Number*" name="batch_number" placeholder="Batch Number" value="" autocomplete="off" field={@form[:batch_number]}/>
        <.input type="text" label="MFGDT*" name="mfgdt" placeholder="MFGDT" value="" autocomplete="off" field={@form[:mfgdt]}/>
        <.input type="text" label="Client ID*" name="client_company_id" placeholder="Cient ID" value="" autocomplete="off" field={@form[:client_company_id]}/>
        <.input type="number" label="Inspection Interval (Months)*" name="inspection_interval" value="0" autocomplete="off" field={@form[:inspection_interval]}/>
        <.input type="date" label="Shelf Date*" name="shelf_date" value="" field={@form[:shelf_date]}/>
        <.input type="date" label="Delivery Date*" name="delivery_date" value="" field={@form[:delivery_date]}/>
        <.input type="date" label="Service Date*" name="service_date" value="" field={@form[:service_date]}/>
        <.input type="date" label="Last Inspection Date*" name="last_inspection_date" value="" field={@form[:last_inspection_date]}/>
        <.input type="date" label="Next Inspection Date*" name="next_inspection_date" value="" field={@form[:next_inspection_date]}/>
        <.input type="date" label="Inactive Date*" name="inactive_date" value="" field={@form[:inactive_date]}/>
        <.button type="submit">Add Equipment</.button>
      </.form>
    </div>
    """
  end

  def handle_event("new_ownership", params, socket) do # TODO[con]: reset form
    EquipmentOwnerships.create_equipment_ownership(params)
    {:noreply, socket}
  end
end
