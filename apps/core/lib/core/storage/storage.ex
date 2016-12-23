defmodule Core.Storage do
  @moduledoc """
  Defines a CRUD behaviour for different storage API implementations.
  """

  @doc "Receive resource"
  @callback get(uid :: Map.t) :: Struct.t | nil
  @doc "Create resource"
  @callback create(uid :: Map.t) :: {:ok, Struct.t} | {:error, any}
  @doc "Update resource"
  @callback update(uid :: Map.t, params :: Map.t) :: {:ok, Struct.t} | {:error, any}
  @doc "Delete resource"
  @callback delete(uid :: Map.t) :: {:ok, Struct.t} | {:error, any}
end
