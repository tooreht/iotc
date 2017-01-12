defmodule NwkSrv.Storage.DB.LoRaWAN.Packet do
  @moduledoc """
  CRUD operations for LoRaWAN.Packet
  """
  @behaviour NwkSrv.Storage

  import Ecto.Query, only: [from: 2]

  alias NwkSrv.LoRaWAN.Packet
  alias NwkSrv.Repo

  #
  # CHANGESET
  #

  def changeset(struct, params \\ %{}) do
    Packet.changeset(struct, params)
  end

  #
  # GET
  #

  def get(%{number: number, node_id: node_id}) do
    Repo.get_by(Packet, number: number, node_id: node_id)
  end

  #
  # CREATE
  #

  def create(%{
    type: type,
    number: number,
    frequency: frequency,
    channel: channel,
    modulation: modulation,
    data_rate: data_rate,
    code_rate: code_rate,
    size: size,
    node_id: node_id
  }) do
    Repo.get_by(NwkSrv.LoRaWAN.Packet, number: number, node_id: node_id) ||
    changeset(%Packet{}, %{
      number: number,
      type: type,
      frequency: frequency,
      channel: channel,
      modulation: modulation,
      data_rate: data_rate,
      code_rate: code_rate,
      size: size,
      node_id: node_id
    }) 
    |> NwkSrv.Repo.insert
  end

  #
  # UPDATE
  #

  def update(%{number: number, node_id: node_id}, params) do
    get(%{number: number, node_id: node_id})
    |> changeset(params)
    |> Repo.update
  end

  #
  # DELETE
  #

  def delete(%{number: number, node_id: node_id}) do
    get(%{number: number, node_id: node_id})
    |> Repo.delete
  end

  #
  # HELPERS
  #

  def exists?(number, node_id) do
    [] != from(p in Packet,
      select: p.id,
      where: [number: ^number, node_id: ^node_id])
      |> Repo.all
  end
end
