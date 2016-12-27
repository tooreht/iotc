defmodule LoRaWAN.Packet do
  @moduledoc """
  LoRaWAN protocol format structure.

  ## Overview

  ### Radio PHY layer

  At this point only the PHYPayload is left, because the rest is all radio specific.

  -------------------------------------------------
  | Preamble | PHDR | PHDR_CRC | PHYPayload | CRC |
  -------------------------------------------------

  ### PHYPayload
  ---------------------------
  | MHDR | MACPayload | MIC |
  ---------------------------

  ### MACPayload
  -----------------------------
  | FHDR | FPort | FRMPayload |
  -----------------------------

  ### FHDR
  ----------------------------------
  | DevAddr | FCtrl | FCnt | FOpts |
  ----------------------------------

  ### FCtrl
  ---------------------------------------------------
  | ADR | ADRAckReq | ACK | RFU/FPending | FOptsLen |
  ---------------------------------------------------
  """

  # defstruct [
  #   phy_payload: nil,
  # ]

  defmodule FCtrl do
    defstruct [
      adr:          nil,
      adr_ack_req:  nil,
      ack:          nil,
      # rfu or f_pending, dynamically injected
      f_opts_len:   nil,
      raw:          nil
    ]
  end

  defmodule FOpts do
    # TODO: Implement the different MAC commands like in chapter 5 of the LoRaWAN specification!
    defstruct [
      raw: nil
    ]
  end

  defmodule FHDR do
    defstruct [
      dev_addr: nil,
      f_ctrl:   %FCtrl{},
      f_cnt:    nil,
      f_opts:   %FOpts{},
      raw:      nil
    ]
  end

  defmodule MHDR do
    defstruct [
      m_type: nil,
      rfu:    nil,
      major:  nil,
      raw:    nil
    ]
  end

  defmodule DataMACPayload do
    defstruct [
      fhdr:         %FHDR{},
      f_port:       nil,
      frm_payload:  nil,
      raw:          nil
    ]
  end

  defmodule JoinMACPayload do
    defstruct [
      app_eui:    nil,
      dev_eui:    nil,
      dev_nonce:  nil,
      raw:        nil  
    ]
  end

    defmodule ProprietaryMACPayload do
    defstruct [
      raw:        nil  
    ]
  end

  defmodule PHYPayload do
    defstruct [
      mhdr:         %MHDR{},
      mac_payload:  nil, #Either DataMacPayload or JoinMACPayload or ProprietaryMACPayload
      mic:          nil,
      raw:          nil,
    ]


  end

  defimpl Inspect, for: LoRaWAN.Packet.PHYPayload do
    def inspect(%LoRaWAN.Packet.PHYPayload{
                     mac_payload: mac_payload,
                     mhdr: mhdr,
                     mic: mic,
                     raw: raw}, _) do
      mhdr = inspect(mhdr)
      mac_payload = inspect(mac_payload)
      mic = inspect(mic)
      raw = inspect(raw)
      """
      #LoRaWAN.Packet.PHYPayload<
      mhdr: #{mhdr} mac_payload: #{mac_payload} mic: #{mic}
      raw: #{raw}
      >
      """
    end
  end

  defimpl Inspect, for: LoRaWAN.Packet.DataMACPayload do
    def inspect(%LoRaWAN.Packet.DataMACPayload{
                     fhdr: fhdr,
                     f_port: f_port,
                     frm_payload: frm_payload,
                     raw: raw}, _) do
      fhdr = inspect(fhdr)
      f_port = inspect(f_port)
      frm_payload = inspect(frm_payload)
      """
      DataMACPayload{
        fhdr: #{fhdr} f_port: #{f_port}, frm_payload: #{frm_payload}
      }
      """
    end
  end

  defimpl Inspect, for: LoRaWAN.Packet.MHDR do
    def inspect(%LoRaWAN.Packet.MHDR{
                     m_type: m_type,
                     rfu: rfu,
                     major: major,
                     raw: raw}, _) do
      m_type = inspect(m_type)
      rfu = inspect(rfu)
      major = inspect(major)
      """
      MHDR{m_type: #{m_type}, rfu: #{rfu}, major: #{major}}
      """
    end
  end

  defimpl Inspect, for: LoRaWAN.Packet.FHDR do
    def inspect(%LoRaWAN.Packet.FHDR{
                dev_addr: dev_addr,
                f_ctrl:   f_ctrl,
                f_cnt:    f_cnt,
                f_opts:   f_opts,
                raw:      raw}, _) do
      dev_addr = inspect(dev_addr)
      f_ctrl = inspect(f_ctrl)
      f_cnt = inspect(f_cnt)
      f_opts = inspect(f_opts)
      """
      FHDR{dev_addr: #{dev_addr}, f_ctrl: #{f_ctrl}  f_cnt: #{f_cnt}, f_opts: #{f_opts}}
      """
    end
  end

  defimpl Inspect, for: LoRaWAN.Packet.FCtrl do
    def inspect(%LoRaWAN.Packet.FCtrl{
                adr: adr,
                adr_ack_req: adr_ack_req,
                ack: ack,
                f_opts_len:   f_opts_len,
                raw:      raw}, _) do
      adr = inspect(adr)
      adr_ack_req = inspect(adr_ack_req)
      ack = inspect(ack)
      f_opts_len = inspect(f_opts_len)
      """
      FCtrl{adr: #{adr}, adr_ack_req: #{adr_ack_req}, ack: #{ack}, f_opts_len: #{f_opts_len}}
      """
    end
  end
end
