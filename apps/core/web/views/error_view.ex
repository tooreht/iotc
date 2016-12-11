defmodule Core.ErrorView do
  use Core.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("401.json", _assigns) do
    %{status: "Unauthorized"}
  end

  def render("404.json", _assigns) do
    %{status: "Not Found"}
  end

  def render("500.json", _assigns) do
    %{status: "Server Error"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
