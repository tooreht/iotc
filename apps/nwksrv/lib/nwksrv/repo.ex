defmodule NwkSrv.Repo do
  use Ecto.Repo, otp_app: :nwksrv
  use Scrivener, page_size: 10
end
