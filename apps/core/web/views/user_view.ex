defmodule Core.UserView do
  use Core.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Core.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Core.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      is_active: user.is_active,
      is_superuser: user.is_superuser}
  end
end
