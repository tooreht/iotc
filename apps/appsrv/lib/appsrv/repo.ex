defmodule AppSrv.Repo do
  use Ecto.Repo, otp_app: :appsrv
  use Scrivener, page_size: 10
end
