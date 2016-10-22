defmodule Handler do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def handle_call(payload, _from, nil) do
    phy_payload = parse_packet(payload)

    IO.puts  phy_payload.mhdr

    {:reply, "Packed handled", nil}
  end

  defp parse_packet(payload) do
    payload_size = byte_size(payload) - 5

    <<
    mhdr    ::  size(1),
    payload ::  size(payload_size),
    mic     ::  size(4)
    >> = payload

    %LoRaWAN.PHYPayload{
      mhdr: mhdr,
      payload: payload,
      mic: mic
    }
  end
end
