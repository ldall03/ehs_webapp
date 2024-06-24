defmodule EhsWebappWeb.AdminPanelLive.CategoriesComponent do
  use EhsWebappWeb, :live_component

  alias EhsWebapp.{Equipments, Equipments.Category, Equipments.Subcategory}

  def hide_form(upd_id, del_id) do
    %JS{}
    |> JS.show(to: del_id, display: "flex")
    |> JS.hide(to: upd_id)
  end

  def mount(socket) do
    categories = Equipments.list_categories
    first_cat = List.first(categories)
    subcategories = Equipments.list_subcategories(first_cat.id)

    socket = assign(socket,
      selected_cat_id: first_cat.id,
      categories: categories,
      subcategories: subcategories
    )
    {:ok, socket} 
  end

  def render(assigns) do 
    ~H"""
    <div class="bg-ccLight w-5/6">
      <div class="font-bold p-8 text-xl">Categories</div>
      <div class="flex">
        <div class="bg-ccGrey-light w-1/5 h-132 relative">
          <div class="h-128 overflow-scroll">
            <%= for cat <- @categories do %>
              <div 
                class={"text-white p-3 text-lg #{if @selected_cat_id == cat.id do 'bg-ccGrey' end} hover:bg-ccGrey"}
                phx-click="select_cat" 
                phx-hook="SwitchCatForms"
                phx-value-cat_id={cat.id}
                id={"cat-#{cat.id}"}
                phx-click-away={hide_form("#upd_cat-#{cat.id}", "#del_cat-#{cat.id}")}
                phx-target={@myself}
              >
                <.form class="flex justify-between w-full" phx-submit="del_cat" phx-target={@myself} id={"del_cat-#{cat.id}"}>
                  <%= cat.category %> 
                  <.input type="hidden" name="cat_id" value={cat.id} />
                  <.button 
                    type="submit" 
                    data-confirm="This action will delete every equipment and subcategory under this category." 
                    class="bg-ccRed hover:bg-ccRed-dark">
                    Del
                  </.button>
                </.form>
                <.form class="flex justify-between w-full" style="display: none" phx-submit="update_cat" phx-target={@myself} id={"upd_cat-#{cat.id}"}>
                  <.input type="hidden" name="cat_id" value={cat.id} />
                  <.input type="text" name="cat" value={cat.category} autocomplete="off" />
                  <.button type="submit" class="bg-ccBlue-light hover:bg-ccBlue">Update</.button>
                </.form>
              </div>
            <% end %>
          </div>
          <.form class="flex justify-between p-3 bg-ccGrey-light w-full absolute bottom-0" phx-submit="new_cat" phx-target={@myself}>
            <.input type="text" name="category" value="" placeholder="Enter a new category..." autocomplete="off" />
            <.button type="submit" class="bg-ccGreen hover:bg-ccGreen-dark">Add</.button>
          </.form>
        </div>
        <div class="bg-ccGrey w-1/5 relative">
          <div class="h-128 overflow-scroll">
            <%= for cat <- @subcategories do %>
              <div class="flex justify-between text-white p-3 text-lg hover:bg-ccGrey"
                phx-hook="SwitchSubForms"
                id={"sub-#{cat.id}"}
                phx-click-away={hide_form("#upd_sub-#{cat.id}", "#del_sub-#{cat.id}")}
                phx-target={@myself}
              >
                <.form class="flex justify-between w-full" phx-submit="del_sub" phx-target={@myself} id={"del_sub-#{cat.id}"}>
                  <%= cat.subcategory %> 
                  <.input type="hidden" name="sub_id" value={cat.id} />
                  <.button 
                    type="submit" 
                    data-confirm="This action will delete every equipment and subcategory under this category." 
                    class="bg-ccRed hover:bg-ccRed-dark">
                    Del
                  </.button>
                </.form>
                <.form class="flex justify-between w-full" style="display: none" phx-submit="update_sub" phx-target={@myself} id={"upd_sub-#{cat.id}"}>
                  <.input type="hidden" name="sub_id" value={cat.id} />
                  <.input type="text" name="sub" value={cat.subcategory} autocomplete="off" />
                  <.button type="submit" class="bg-ccBlue-light hover:bg-ccBlue">Update</.button>
                </.form>
              </div>
            <% end %>
          </div>
          <.form class="flex justify-between p-3 w-full absolute bottom-0" phx-submit="new_sub" phx-target={@myself}>
            <.input type="hidden" name="category_id" value={@selected_cat_id} />
            <.input type="text" name="subcategory" value="" placeholder="Enter a new subcategory..." autocomplete="off" />
            <.button type="submit" class="bg-ccGreen hover:bg-ccGreen-dark">Add</.button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("new_cat", %{"category" => _category} = changeset, socket) do
    Equipments.create_category(changeset)
    categories = Equipments.list_categories
    socket = assign(socket,
      categories: categories
    )
    {:noreply, socket}
  end

  def handle_event("new_sub", %{"category_id" => _category_id, "subcategory" => _subcategory} = changeset, socket) do
    Equipments.create_subcategory(changeset)
    subcategories = Equipments.list_subcategories(socket.assigns.selected_cat_id)
    socket = assign(socket,
    subcategories: subcategories)
    {:noreply, socket}
  end

  def handle_event("del_cat", %{"cat_id" => id}, socket) do
    Equipments.delete_category(%Category{id: String.to_integer id})
    categories = Equipments.list_categories
    first_cat = List.first(categories)
    subcategories = Equipments.list_subcategories(first_cat.id)
    socket = assign(socket,
      selected_cat_id: first_cat.id,
      categories: categories,
      subcategories: subcategories
    )
    {:noreply, socket}
  end

  def handle_event("del_sub", %{"sub_id" => id}, socket) do
    Equipments.delete_subcategory(%Subcategory{id: String.to_integer id})
    subcategories = Equipments.list_subcategories(socket.assigns.selected_cat_id)
    socket = assign(socket,
      subcategories: subcategories
    )
    {:noreply, socket}
  end

  def handle_event("update_cat", %{"cat_id" => id, "cat" => category}, socket) do
    Equipments.update_category(%Category{id: String.to_integer(id)}, %{category: category})
    categories = Equipments.list_categories
    socket = assign(socket,
      categories: categories
    )
    {:noreply, socket}
  end

  def handle_event("update_sub", %{"sub_id" => id, "sub" => subcategory}, socket) do
    Equipments.update_subcategory(%Subcategory{
        id: String.to_integer(id),
        category_id: socket.assigns.selected_cat_id
      },
      %{subcategory: subcategory})
    subcategories = Equipments.list_subcategories(socket.assigns.selected_cat_id)
    socket = assign(socket,
      subcategories: subcategories
    )
    {:noreply, socket}
  end

  def handle_event("select_cat", %{"cat_id" => id}, socket) do
    subcategories = Equipments.list_subcategories(String.to_integer(id))
    socket = assign(socket,
      selected_cat_id: String.to_integer(id),
      subcategories: subcategories
    )
    {:noreply, socket}
  end
  
end
