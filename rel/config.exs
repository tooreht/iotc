use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :iotc,
    # This sets the default environment used by `mix release`
    default_environment: :prod

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"GxS}*X_r(Mgk=xhPX,?Nd51~6=R(nC2r4{;{$yQ}krod&@MG~K/i3;K6pbqJahM="
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"4ieq6ZK;6W895>sbOuB|}C{B@RdA|>djee]O&>_B<Q[uJkbq}aHTvNJqU}mM[})?"
  set post_start_hook: "rel/hooks/post_start"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :iotc do
  set version: "0.1.0"
  set applications: [
    appsrv: :permanent,
    nwksrv: :permanent,
    kv: :permanent,
    lorawan: :permanent,
    semtech: :permanent
  ]
end

