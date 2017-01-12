defmodule AppSrv.Mocks.Storage.DB.LoRaWAN.Node do
  @moduledoc """
  Mock for CRUD operations of `NwkSrv.Storage.DB.LoRaWAN.Node`.
  """

  #
  # GET
  #

  def get(%{dev_eui: dev_eui}) do
    %{dev_eui: dev_eui}
  end

  #
  # CREATE
  #

  def create(%{
    dev_eui: _,
    nwk_s_key: _,
    application__app_eui: _,
    user__email: _}) do
    {:ok, nil} # We don't care about the returned node for now
  end

  #
  # UPDATE
  #

  def update(%{dev_eui: dev_eui}, params) do
    {:ok, nil} # We don't care about the returned node for now
  end

  #
  # DELETE
  #

  def delete(%{dev_eui: dev_eui}) do
    {:ok, nil} # We don't care about the returned node for now
  end
end
