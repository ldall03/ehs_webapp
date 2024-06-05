defmodule EhsWebappWeb.AdminPanelLive do
  use EhsWebappWeb, :live_view

  alias Phoenix.LiveView.JS

  alias EhsWebapp.Equipments
  alias EhsWebapp.Equipments.{Category, Subcategory}

  def hide_form(upd_id, del_id) do
    %JS{}
    |> JS.show(to: del_id, display: "flex")
    |> JS.hide(to: upd_id)
  end

  def mount(_params, _session, socket) do
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
