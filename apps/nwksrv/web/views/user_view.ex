defmodule NwkSrv.UserView do
  use NwkSrv.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, NwkSrv.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, NwkSrv.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      username: user.username,
      is_active: user.is_active,
      is_superuser: user.is_superuser}
  end
end
