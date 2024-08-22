defmodule EhsWebappWeb.AdminPanelLive.EquipmentsComponent do
  use EhsWebappWeb, :live_component
  
  alias EhsWebapp.{Equipments, Equipments.Equipment}

  def toggle_file_upload(js \\ %JS{}) do
    js
    |> JS.toggle_class("overflow-hidden", to: "body")
    |> JS.toggle(to: "#file-upload-backdrop")
    |> JS.toggle(to: "#file-upload-container")
  end

  def mount(socket) do
    socket = assign(socket,
      form: to_form(Equipments.change_equipment(%Equipment{})),
    )
    {:ok, socket 
      |> allow_upload(:files, accept: ~w(.pdf), max_file_size: 1_000_000, auto_upload: true)
      |> assign(form: to_form(%{}), selection: %Equipment{}, file_prefix: "manual")
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
      <div class="flex">
        <div class="w-3/4 flex bg-white mx-5 p-5 rounded-lg border-ccGrey">
          <.form id="equipment_form" for={@form} phx-submit="save" phx-target={@myself} autocomplete="off" class="w-full">
            <.input type="hidden" name="equipment_id" field={@form[:id]} />
            <.input type="text" phx-debounce="blur" label="Equipment Name*" placeholder="Equipment Name..." name="equipment" field={@form[:equipment]} required />
            <.input type="text" phx-debounce="blur" label="Part No.*" placeholder="Part Number..." name="part_number" field={@form[:part_number]} required />
            <.live_component module={EhsWebappWeb.CategorySelectComponent} id="category_select" parent_form={@form} required={true} />
            <.input class="mb-4" type="text" phx-debounce="blur" label="Brand*" placeholder="Brand..." name="brand" field={@form[:brand]} required />
            <.button type="submit" class={if @selection.id, do: "bg-ccBlue", else: "bg-ccGreen hover:bg-ccGreen-dark"}><%= if @selection.id, do: "Update Equipment", else: "New Equipment" %></.button>
          </.form>
        </div>
        <div class="w-1/4 bg-white mr-5 p-10 rounded-lg border-ccGrey flex flex-col">
          <.form id="file_type_form" phx-change="set_file_prefix" phx-target={@myself}>
            <.select_button id="file_type" 
              click_action={toggle_file_upload()} 
              disabled={!@selection.id} 
              options={[{"Upload Manual", "manual"}, {"Upload Brochure", "brochure"}, {"Upload Spec Sheet", "spec_sheet"}, {"Upload Cert. of Conf.", "certificate"}]} 
              class="float-left w-2/3 mb-5" 
              value={@file_prefix}
            />
          </.form>
          <.link href={@selection.manual_url} target="_blank" class={["p-4 text-lg", if(@selection.id && @selection.manual_url, do: "text-ccBlue hover:underline", else: "text-ccGrey cursor-default pointer-events-none")]}>Manual</.link>
          <.link href={@selection.brochure_url} target="_blank" class={["p-4 text-lg", if(@selection.id && @selection.brochure_url, do: "text-ccBlue hover:underline", else: "text-ccGrey cursor-default pointer-events-none")]}>Brochure</.link>
          <.link href={@selection.spec_sheet_url} target="_blank" class={["p-4 text-lg", if(@selection.id && @selection.spec_sheet_url, do: "text-ccBlue hover:underline", else: "text-ccGrey cursor-default pointer-events-none")]}>Spec Sheet</.link>
          <.link href={@selection.certificate_url} target="_blank" class={["p-4 text-lg", if(@selection.id && @selection.certificate_url, do: "text-ccBlue hover:underline", else: "text-ccGrey cursor-default pointer-events-none")]}>Certificate of Conformance</.link>
        </div>
      </div>

      <div id="file-upload-backdrop" class="hidden fixed backdrop-blur-sm bg-ccTransparent overscroll-contain top-0 bottom-0 right-0 left-0 opacity-70"></div>
      <div id="file-upload-container" class="hidden fixed w-3/5 left-0 right-0 top-0 bottom-0 m-auto border-2 border-ccBlue rounded-xl bg-white h-128 p-1">
        <div class="text-xl m-6">Select the document you want to upload:</div>
        <div class="flex">
          <div class="bg-sky-500 w-1"></div>
          <div class="py-6 px-8 bg-sky-200 w-full">Maximum file size allowed for upload: 1 Mb</div>
        </div>
        <p class="text-ccRed text-sm h-6">NOTE: this will overwrite the currently existing file.</p>
        <section phx-drop-target={@uploads.files.ref} class="text-center w-full border-2 border-dashed border-ccGrey-light rounded p-4 mb-6 justify-center h-56">
          <p class="text-xl font-light my-4">Drag and drop document here</p>
          <p class="text-xl font-light mt-4 mb-10">or</p>
          <.form for={to_form(%{})} phx-change="upload_validate" phx-submit={JS.push("upload") |> toggle_file_upload()} id="upload_form" phx-target={@myself}>
            <.live_file_input upload={@uploads.files} class="sr-only" />
            <.input type="hidden" name="file_prefix" value={@file_prefix} id="file_prefix_input" />
            <label for={@uploads.files.ref} class="bg-ccBlue hover:bg-ccBlue-dark py-2.5 px-6 text-white rounded-lg cursor-pointer">Select File</label>
          </.form>
        </section>
        <div class="h-28">
          <%= for file <- @uploads.files.entries do %>
            <p class="font-bold px-4"><%= "#{file.client_name} (#{format_file_size(file.client_size)})" %></p>
            <progress value={file.progress} max="100" class="mx-4 w-1/2 h-8 rounded-lg [&::-webkit-progress-value]:bg-ccGreen [&::-moz-progress-bar]:bg-ccGreen"><%= file.progress %>%</progress>
            <%= if file.progress > 0 do %>
              <p class="text-sm px-6"><%= if file.progress < 100, do: "Uploading...", else: "Complete" %></p>
            <% end %>
            <%= for err <- upload_errors(@uploads.files, file) do %>
              <p class="text-sm px-6 text-ccRed"><%= error_to_string(err) %></p>
            <% end %>
          <% end %>
          <%= for err <- upload_errors(@uploads.files) do %>
            <p class="text-sm px-6 text-ccRed"><%= error_to_string(err) %></p>
          <% end %>
        </div>
        <div>
          <.button class="float-right w-36 mx-4 my-2 bg-ccGreen hover:bg-ccGreen-dark disabled:bg-ccGrey disabled:hover:bg-ccGrey disabled:active:text-ccGrey disabled:text-ccGrey-light" 
            form="upload_form" type="submit" disabled={length(@uploads.files.entries) == 0}>Confirm
          </.button>
          <.button class="float-right w-36 mx-4 my-2 bg-ccOrange hover:bg-ccOrange-dark" phx-target={@myself}
            phx-value-ref={length(@uploads.files.entries) > 0 && Enum.at(@uploads.files.entries, 0).ref} 
            phx-click={JS.push("cancel_upload") |> toggle_file_upload()}>Close
          </.button>
        </div>
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
    IO.inspect(params)
    selected = Equipments.get_equipment!(socket.assigns.selection.id)
    case Equipments.update_equipment(selected, params) do
      {:ok, equipment} -> {:noreply, socket 
        |> stream_insert(:equipments, equipment |> Map.put(:selected, true)) 
        |> assign(form: to_form(Equipments.change_equipment(equipment)), selection: equipment)
        |> send_flash(:info, "Update was successful!")}
      {:error, changeset} -> {:noreply, socket |> send_flash(:error, "Something went wrong...") |> assign(form: to_form(changeset))}
    end
  end

  def handle_event("set_file_prefix", %{"select_value" => prefix}, socket) do
    {:noreply, assign(socket, file_prefix: prefix)}
  end

  def handle_event("upload_validate", params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload", %{"file_prefix" => file_type}, socket) do
    [url] = consume_uploaded_entries(socket, :files, fn meta, entry ->
      url = "/uploads/equipment_files/#{entry.uuid}.pdf"
      dest = Path.join(Application.app_dir(:ehs_webapp, "priv/static"), url)
      var = case File.cp!(meta.path, dest) do
        :ok -> {:ok, url}
        _   -> {:error, url}
      end
    end)

    update_equipment(socket, %{"#{socket.assigns.file_prefix}_url" => url})
  end

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :files, ref)}
  end

  def handle_event("cancel_upload", _params, socket) do
    {:noreply, socket}
  end

  defp error_to_string(:too_large), do: "File is too large"
  defp error_to_string(:not_accepted), do: "Only .pdf files are allowed"
  defp error_to_string(:too_many_files), do: "You may only choose one file"
  defp format_file_size(size) do
    if size > 1_000_000 do
      "#{Float.round(size / 1_000_000, 2)} Mb"
    else
      "#{Float.round(size / 1000, 1)} Kb"
    end
  end
end
