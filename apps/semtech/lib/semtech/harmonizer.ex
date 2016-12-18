defmodule Semtech.Harmonizer do
  @moduledoc """
  This module translates between the Semtech protocol format and the internal `LoRaWAN.Gateway.Packet` format.
  """

  @doc """
  Harmonizes formats based on the identifier.
  """
  def harmonize(gateway_ip, packet) do
    case packet.identifier do
      0x00 ->
        # Check if packet has gateway meta data.
        meta = case packet.payload.stat do
          true ->
            %{
              time: packet.payload.stat.time,
              lat: packet.payload.stat.lati,
              lng: packet.payload.stat.long,
              alt: packet.payload.stat.alti,
              rx: %{
                total: packet.payload.stat.rxnb,
                valid: packet.payload.stat.rxok,
                forwarded: packet.payload.stat.rxfw
              },
              tx: %{
                received: packet.payload.stat.dwnb,
                emitted: packet.payload.stat.txnb
              },
              ack_rate: packet.payload.stat.ackr
            }
          _ -> nil
        end

        # Check if packet has mote packets.
        packets = case length(packet.payload.rxpk) > 0 do
          true ->
            for rxpk <- packet.payload.rxpk do
              crc_status = case rxpk.stat do
                -1 -> :fail
                 0 -> :ok
                 1 -> :no_crc
              end
              %{
                payload: rxpk.data,
                meta: %{
                  time: rxpk.time,
                  epoch: rxpk.tmst,
                  channel: rxpk.chan,
                  rf_chain: rxpk.rfch,
                  frequency: rxpk.freq,
                  crc_status: crc_status,
                  modulation: rxpk.modu,
                  data_rate: rxpk.datr,
                  code_rate: rxpk.codr,
                  rssi: rxpk.rssi,
                  snr: rxpk.lsnr,
                  size: rxpk.size
                }
              }
            end
          _ -> []
        end

        # Assemble internal gateway packet
        %LoRaWAN.Gateway.Packet{
          adapter: "Semtech",
          protocol: %{
            version: packet.version
          },
          id: packet.token,
          gateway: %{
            eui: packet.gateway_id,
            ip: gateway_ip,
            meta: meta
          },
          lorawan: packets
        }
      0x02 ->
        # Assemble internal gateway packet
        %LoRaWAN.Gateway.Packet{
          adapter: "Semtech",
          protocol: %{
            version: packet.version
          },
          id: packet.token,
          gateway: %{
            eui: packet.gateway_id,
            ip: gateway_ip,
          },
          lorawan: []
        }
      0x03 ->
        %Semtech.PullResp{
          version: packet.protocol.version,
          token: packet.id,
          identifier: 0x03,
          payload: %Semtech.PullResp.TxPk{
            txpk: %{
              imme: packet.lorawan[0].meta.send_immediately,
              tmst: packet.lorawan[0].meta.epoch,
              time: packet.lorawan[0].meta.time,
              freq: packet.lorawan[0].meta.frequency,
              rfch: packet.lorawan[0].meta.rf_chain,
              powe: packet.lorawan[0].meta.power,
              modu: packet.lorawan[0].meta.modulation,
              datr: packet.lorawan[0].meta.data_rate,
              codr: packet.lorawan[0].meta.code_rate,
              fdev: packet.lorawan[0].meta.fsk_deviation,
              ipol: packet.lorawan[0].meta.inverse_polarisation,
              prea: packet.lorawan[0].meta.preamble_size,
              size: packet.lorawan[0].meta.size,
              ncrc: packet.lorawan[0].meta.no_crc,
              data: packet.lorawan[0].payload
            }
          }
        }
      0x05 ->
        # Assemble internal gateway packet
        %LoRaWAN.Gateway.Packet{
          adapter: "Semtech",
          protocol: %{
            version: packet.version
          },
          id: packet.token,
          gateway: %{
            eui: nil,  # Not supplied by the gateway
            ip: gateway_ip,
          },
          lorawan: [],
          error: packet.payload.txpk_ack.error
        }
      _ -> nil
    end
  end
end
