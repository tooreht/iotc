defmodule Appsrv.CORS do
  use Corsica.Router,
    # TODO: Add real CORS handling, not just "*"
    origins: "*",
    allow_headers: ~w(x-auth-token),
    max_age: 600

  resource "/api/*"
  resource "/core/api/*"
  # We can override single settings as well.
  # resource "/public/*", allow_credentials: false
end
