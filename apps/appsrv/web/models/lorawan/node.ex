defmodule AppSrv.LoRaWAN.Node do
  use AppSrv.Web, :model

  schema "lorawan_nodes" do
    field :name, :string
    field :dev_eui, :string
    field :dev_addr, :string
    field :app_key, :string
    field :app_s_key, :string
    field :nwk_s_key, :string
    field :relax_fcnt, :boolean, default: false
    field :rx_window, :integer
    field :rx_delay, :integer
    field :rx1_dr_offset, :integer
    field :rx2_dr, :integer
    belongs_to :application, AppSrv.LoRaWAN.Application
    belongs_to :user, AppSrv.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :dev_eui, :dev_addr, :app_key, :app_s_key, :nwk_s_key, :relax_fcnt, :rx_window, :rx_delay, :rx1_dr_offset, :rx2_dr, :application_id, :user_id])
    |> validate_required([:name, :dev_eui, :dev_addr, :app_key, :app_s_key, :nwk_s_key, :application_id, :user_id])
    |> validate_format(:dev_eui, ~r/[a-fA-F0-9]{16}/) # 64bit HEX string
    |> validate_format(:dev_addr, ~r/[a-fA-F0-9]{8}/) # 32bit HEX string
    |> validate_format(:app_key, ~r/[a-fA-F0-9]{32}/) # 128 HEX string
    |> validate_format(:app_s_key, ~r/[a-fA-F0-9]{32}/) # 128 HEX string
    |> validate_format(:nwk_s_key, ~r/[a-fA-F0-9]{32}/) # 128 HEX string
    |> unique_constraint(:dev_eui)
  end
end
