defmodule Appsrv.Mocks.Storage.DB.LoRaWAN.Application do
  @moduledoc """
  Mock for CRUD operations of `Core.Storage.DB.LoRaWAN.Application`.
  """

  #
  # GET
  #

  def get(%{app_eui: app_eui}) do
    %{app_eui: app_eui}
  end

  #
  # CREATE
  #

  def create(%{app_eui: _, user__email: _}) do
    {:ok, nil} # We don't care about the returned application for now
  end

  #
  # UPDATE
  #

  def update(%{app_eui: app_eui}, params) do
    {:ok, nil} # We don't care about the returned application for now
  end

  #
  # DELETE
  #

  def delete(%{app_eui: app_eui}) do
    {:ok, nil} # We don't care about the returned application for now
  end
end
