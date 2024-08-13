defmodule EhsWebappWeb.AdminPanelLive.EquipmentsComponent do
  use EhsWebappWeb, :live_component
  
  alias EhsWebapp.{Equipments, Equipments.Equipment}

  def mount(socket) do
    socket = assign(socket,
      form: to_form(Equipments.change_equipment(%Equipment{})),
    )
    {:ok, socket 
      |> assign(form: to_form(%{}), selection: %Equipment{})
      |> stream(:equipments, 
        Equipments.list_equipments() |> Enum.map(fn i -> 
          %{id: i.id,
            part_number: i.part_number,
            equipment: i.equipment,
            brand: i.brand,
            selected: false}
        end)
      )
    }
  end

  def render(assigns) do 
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Equipments</div>
      <div class="bg-white m-5 py-5 rounded-lg border-ccGrey">
        <div class="flex justify-between py-4">
          <p class="w-full text-center font-bold">Name</p>
          <p class="w-full text-center font-bold">Part Number</p>
          <p class="w-full text-center font-bold">Brand</p>
        </div>
        <div id="equipments" phx-update="stream" class="h-96 overflow-scroll">
          <%= for {dom_id, equipment} <- @streams.equipments do %>
            <div class={["flex justify-between py-3 m-1 rounded select-none", equipment.selected && "bg-ccBlue text-white"]} phx-value-id={equipment.id} phx-click="select" phx-target={@myself} id={dom_id}>
              <p class="w-full text-center cursor-default"><%= equipment.equipment %></p>
              <p class="w-full text-center cursor-default"><%= equipment.part_number %></p>
              <p class="w-full text-center cursor-default"><%= equipment.brand %></p>
            </div>
          <% end %>
        </div>
      </div>
      <div class="bg-white m-5 p-5 rounded-lg border-ccGrey">
        <.form id="equipment_form" for={@form} phx-submit="save" phx-target={@myself} autocomplete="off">
          <.input type="hidden" name="equipment_id" field={@form[:id]} />
          <.input type="text" phx-debounce="blur" label="Equipment Name*" placeholder="Equipment Name..." name="equipment" field={@form[:equipment]} required />
          <.input type="text" phx-debounce="blur" label="Part No.*" placeholder="Part Number..." name="part_number" field={@form[:part_number]} required />
          <.live_component module={EhsWebappWeb.CategorySelectComponent} id="category_select" parent_form={@form} required={true} />
          <.input class="mb-4" type="text" phx-debounce="blur" label="Brand*" placeholder="Brand..." name="brand" field={@form[:brand]} required />
          <.button type="submit" class={if @selection.id, do: "bg-ccBlue", else: "bg-ccGreen hover:bg-ccGreen-dark"}><%= if @selection.id, do: "Update Equipment", else: "New Equipment" %></.button>
        </.form>
      </div>
    </div>
    """
  end

  def handle_event("save", params, socket) do 
    if params["equipment_id"] == "" do
      new_equipment(socket, params)
    else
      update_equipment(socket, params)
    end
  end

  def handle_event("select", params, socket) do
    if params["id"] == to_string(socket.assigns.selection.id) do # Deselect
      {:noreply, 
        socket
        |> stream_insert(:equipments, socket.assigns.selection |> Map.put(:selected, false))
        |> assign(
          selection: %Equipment{},
          form: to_form(Equipments.change_equipment(%Equipment{}))
        )
      }
    else
      selection = Equipments.get_equipment!(String.to_integer(params["id"]))
      deselect = socket.assigns.selection |> Map.put(:selected, false)
      select = selection |> Map.put(:selected, true)

      send_update(EhsWebappWeb.CategorySelectComponent, id: "category_select", parent_form: to_form(%{"subcategory_id" => selection.subcategory_id}))

      {:noreply, 
        socket
        |> stream(:equipments, if(deselect.id, do: [deselect, select], else: [select]))
        |> assign(
          selection: selection,
          form: to_form(Equipments.change_equipment(selection))
        ) 
      }
    end
  end

  defp send_flash(socket, type, message) do
    send(self(), {:put_flash, type, message})
    socket
  end

  defp new_equipment(socket, params) do
    case Equipments.create_equipment(params) do
      {:ok, equipment} -> {:noreply, socket 
        |> stream_insert(:equipments, equipment |> Map.put(:selected, false)) 
        |> assign(form: to_form(Equipments.change_equipment(%Equipment{})))
        |> send_flash(:info, "New equipment created!")}
      {:error, changeset} -> {:noreply, socket 
        |> assign(form: to_form(changeset))
        |> send_flash(:error, "Something went wrong...")}
    end
  end

  defp update_equipment(socket, params) do
    selected = Equipments.get_equipment!(String.to_integer(params["equipment_id"]))
    case Equipments.update_equipment(selected, params) do
      {:ok, equipment} -> {:noreply, socket 
        |> stream_insert(:equipments, equipment |> Map.put(:selected, true)) 
        |> assign(form: to_form(Equipments.change_equipment(equipment)), selection: equipment)
        |> send_flash(:info, "Update was successful!")}
      {:error, changeset} -> {:noreply, socket |> send_flash(:error, "Something went wrong...") |> assign(form: to_form(changeset))}
    end
  end
end
