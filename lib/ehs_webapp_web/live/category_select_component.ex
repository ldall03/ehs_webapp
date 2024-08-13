defmodule EhsWebappWeb.CategorySelectComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.Equipments

  def mount(socket) do # TODO: stream categories
    socket = assign(socket,
      categories: Equipments.list_categories(),
      subcategories: [],
      disabled: true
    )
    {:ok, socket}
  end

  def update(assigns, socket) do
    socket = if !Map.has_key?(assigns, :required), do: assign(socket, required: false), else: socket
    if assigns.parent_form[:subcategory_id].value && assigns.parent_form[:subcategory_id].value != "" do
      subcategory = Equipments.get_subcategory!(assigns.parent_form[:subcategory_id].value)
      {:ok, assign(socket, 
        parent_form: to_form(%{"category_id" => subcategory.category_id, "subcategory_id" => subcategory.id}),
        subcategories: Equipments.list_subcategories(subcategory.category_id),
        disabled: false,
      )}
    else
      {:ok, assign(socket, assigns)}
    end
  end

  def render(assigns) do 
    ~H"""
    <div>
      <.input type="select" label="Category" name="category_id" phx-change="cat_change" phx-target={@myself} field={@parent_form[:category_id]} required={@required}
        options={[{"", ""} | Enum.map(@categories, fn cat -> {cat.category, cat.id} end)]}
      />
      <.input type="hidden" name="subcategory_id" value="" disabled={!@disabled} />
      <.input type="select" label="Subcategory" name="subcategory_id" id="subcat_select" disabled={@disabled} field={@parent_form[:subcategory_id]} required={@required}
        options={[ {"", ""} | Enum.map(@subcategories, fn cat -> {cat.subcategory, cat.id} end)]}
      />
    </div>
    """
  end

  def handle_event("cat_change", %{"category_id" => "" = id} = params, socket) do
    {:noreply, 
      assign(socket, 
        subcategories: [],
        disabled: true,
        parent_form: to_form(params)
      )
    }
  end

  def handle_event("cat_change", %{"category_id" => id} = params, socket) do
    {:noreply,
      assign(socket, 
        subcategories: Equipments.list_subcategories(String.to_integer(id)),
        disabled: false,
        parent_form: to_form(params |> Map.put("subcategory_id", socket.assigns.parent_form[:subcategory_id].value))
      )
    }
  end
end
