defmodule AppSrv.CORS do
  use Corsica.Router,
    # TODO: Add real CORS handling, not just "*"
    origins: "*",
    allow_headers: ~w(x-auth-token),
    max_age: 600

  resource "/api/*"
  resource "/nwksrv/api/*"
  # We can override single settings as well.
  # resource "/public/*", allow_credentials: false
end
