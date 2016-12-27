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
end
