# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rocketchat.Repo.insert!(%Rocketchat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for title <- ["Home Improvement", "Power Tools", "Gardening", "Books", "Education"] do
  Rocketchat.Catalog.create_category(%{title: title})
end

category_ids = Rocketchat.Catalog.list_categories() |> Enum.map(& &1.id)

for i <- 1..10 do
  Rocketchat.Catalog.create_product(%{
    description: "Product #{i} description",
    price: i * 11,
    title: "Product #{i}",
    category_ids: Enum.take_random(category_ids, 2)
  })
end

for c <- ?A..?Z, i <- 1..3 do
  l = <<c::utf8>>

  Rocketchat.Blog.create_post(%{
    title: "#{l} Post #{i}",
    body: "Thie is a blog post number #{i} for letter #{l}."
  })
end
