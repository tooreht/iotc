defmodule LoRaWAN.Frame do
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
  """

  defstruct [
    phy_payload: nil,
    raw: nil
  ]

  defmodule FCtrl do
    defstruct [
      adr: nil,
      adr_ack_req: nil,
      ack: nil,
      # rfu or f_pending, dynamically injected
      f_opts_len: nil
    ]
  end

  defmodule FOpts do
    # TODO: Implement the different MAC commands like in chapter 5 of the LoRaWAN specification!
    defstruct [

    ]
  end

  defmodule FHDR do
    defstruct [
      dev_addr: nil,
      f_ctrl: %FCtrl{},
      f_cnt: nil,
      f_opts: %FOpts{}
    ]
  end

  defmodule MHDR do
    @moduledoc """

    """
    defstruct [
      m_type: nil,
      rfu: nil,
      major: nil
    ]
  end

  defmodule MACPayload do
    defstruct [
      fhdr: %FHDR{},
      f_port: 0,
      frm_payload: nil
    ]
  end

  defmodule PHYPayload do
    defstruct [
      mhdr: %MHDR{},
      mac_payload: %MACPayload{},
      mic: nil
    ]
  end

  defmodule Raw do
    defstruct [
      phy_payload: nil,
      mhdr: nil,
      mac_payload: nil,
      mic: nil,
      fhdr: nil,
      f_ctrl: nil
    ]
  end
end
