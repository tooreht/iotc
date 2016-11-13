defmodule LoRaWAN.Gateway.Packet do
  @moduledoc """
  This module represents a LoRaWAN gateway packet.
  """

  defstruct [
    adapter: nil,
    protocol: %{
      version: nil,
    },
    id: nil,
    gateway: %{
      id: nil,
      ip: nil,
      meta: %{
        time: nil,
        lat: nil,
        lng: nil,
        alt: nil,
        rx: %{
          total: nil,
          valid: nil,
          forwarded: nil
        },
        tx: %{
          received: nil,
          emitted: nil
        },
        ack_rate: nil
      }
    },
    lorawan: [
      payload: nil,
      meta: %{
        send_immediately: nil,
        epoch: nil,
        time: nil,
        frequency: nil,
        rf_chain: nil,
        power: nil,
        modulation: nil,
        data_rate: nil,
        code_rate: nil,
        fsk_deviation: nil,
        inverse_polarisation: nil,
        preamble_size: nil,
        size: nil,
        no_crc: nil
      },
    ],
    error: nil
  ]
end
