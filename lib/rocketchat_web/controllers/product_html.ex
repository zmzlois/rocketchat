defmodule RocketchatWeb.ProductHTML do
  use RocketchatWeb, :html

  def index(assigns) do
    ~H"""
    <.header>
      Listing Products
      <:actions>
        <.link href={~p"/products/new"}>
          <.button>New Product</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="products" rows={@products} row_click={&JS.navigate(~p"/products/#{&1}")}>
      <:col :let={product} label="Title"><%= product.title %></:col>
      <:col :let={product} label="Description"><%= product.description %></:col>
      <:col :let={product} label="Price"><%= product.price %></:col>
      <:col :let={product} label="Views"><%= product.views %></:col>
      <:action :let={product}>
        <div class="sr-only">
          <.link navigate={~p"/products/#{product}"}>Show</.link>
        </div>
        <.link navigate={~p"/products/#{product}/edit"}>Edit</.link>
      </:action>
      <:action :let={product}>
        <.link href={~p"/products/#{product}"} method="delete" data-confirm="Are you sure?">
          Delete
        </.link>
      </:action>
    </.table>
    """
  end

  def show(assigns) do
    ~H"""
    <.header>
      Product <%= @product.id %>
      <:subtitle>This is a product record from your database.</:subtitle>
      <:actions>
        <.link href={~p"/products/#{@product}/edit"}>
          <.button>Edit product</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Title"><%= @product.title %></:item>
      <:item title="Description"><%= @product.description %></:item>
      <:item title="Price"><%= @product.price %></:item>
      <:item title="Views"><%= @product.views %></:item>
      <:item title="Categories">
        <ul>
          <li :for={c <- @product.categories}>
            <%= c.title %>
          </li>
        </ul>
      </:item>
    </.list>

    <.back navigate={~p"/products"}>Back to products</.back>
    """
  end

  def new(assigns) do
    ~H"""
    <.header>
      New Product
      <:subtitle>Use this form to manage product records in your database.</:subtitle>
    </.header>

    <.product_form changeset={@changeset} action={~p"/products"} />

    <.back navigate={~p"/products"}>Back to products</.back>
    """
  end

  def edit(assigns) do
    ~H"""
    <.header>
      Edit Product <%= @product.id %>
      <:subtitle>Use this form to manage product records in your database.</:subtitle>
    </.header>

    <.product_form changeset={@changeset} action={~p"/products/#{@product}"} />

    <.back navigate={~p"/products"}>Back to products</.back>
    """
  end

  @doc """
  Renders a product form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def product_form(assigns) do
    ~H"""
    <.simple_form :let={f} for={@changeset} action={@action}>
      <.error :if={@changeset.action}>
        Oops, something went wrong! Please check the errors below.
      </.error>
      <.input field={f[:title]} type="text" label="Title" />
      <.input field={f[:description]} type="text" label="Description" />
      <.input field={f[:price]} type="number" label="Price" step="any" />
      <.input
        field={f[:category_ids]}
        type="select"
        multiple
        label="Categories"
        options={category_opts(@changeset)}
      />
      <:actions>
        <.button>Save Product</.button>
      </:actions>
    </.simple_form>
    """
  end

  def category_opts(changeset) do
    existing_ids =
      Ecto.Changeset.get_change(changeset, :categories, [])
      |> Enum.map(& &1.data.id)

    for cat <- Rocketchat.Catalog.list_categories(),
        do: [key: cat.title, value: cat.id, selected: cat.id in existing_ids]
  end
end
