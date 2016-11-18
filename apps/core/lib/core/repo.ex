defmodule Core.Repo do
  use Ecto.Repo, otp_app: :core
  use Scrivener, page_size: 10
end
