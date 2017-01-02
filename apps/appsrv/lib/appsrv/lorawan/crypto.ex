defmodule Appsrv.LoRaWAN.Crypto do

  use Bitwise

  # TODO: Move this to LoRaWAN library!

  @doc """
  The key K used depends on the FPort of the data message:

        FPort     |       K
  ---------------------------------
  |       0       |   nwk_s_key   |
  ---------------------------------
  |     1..255    |   app_s_key   |
  ---------------------------------

  The fields encrypted are:

      pld = FRMPayload

  For each data message, the algorithm defines a sequence of Blocks Ai for i = 1..k with k = ceil(len(pld) / 16):

                    -------------------------------------------------------------------------------
       Size (bytes) |     1    |    4     |    1     |    4     |    4      |    1     |    1     |
      --------------|----------|----------|----------|----------|-----------|----------|-----------
                 Ai |   0x01   | 4 x 0x00 |    Dir   | DevAddr  | FCntUp or |   0x00   |    i     |
                    |          |          |          |          | FCntDown  |          |          |
                    |          |          |          |          |           |          |          |
                    -------------------------------------------------------------------------------

  The direction field (Dir) is 0 for uplink packets and 1 for downlink packets.
  The blocks Ai are encrypted to get a sequence S of blocks Si:

      Si = aes128_encrypt(K, Ai) for i = 1..k
      S  = S1 | S2 | .. | Sk

  Encryption and decryption of the payload is done by truncating

      (pld | pad16) xor S

  to the first len(pld) octets.
  """
  def decrypt(packet, key) do
    dev_addr = packet.mac_payload.fhdr.dev_addr

    pld = packet.mac_payload.frm_payload
    pld_size = byte_size(pld)
    pld_pad =
    if rem(pld_size, 16) != 0 do
      pad_bits = (16 - rem(pld_size, 16)) * 8
      pld_pad = IO.iodata_to_binary [pld, <<0::size(pad_bits)>>]
    else
      pld
    end

    k = round(Float.ceil((pld_size) / 16))
    blocks = for i <- 1..k do
      ai = IO.iodata_to_binary [1, 0, 0, 0, 0, 0, dev_addr, <<packet.mac_payload.fhdr.f_cnt::little-unsigned-integer-size(32)>>, 0, <<i::8>>]
      :crypto.block_encrypt(:aes_ecb, key, ai)
    end
    s = Enum.join(blocks) |> :erlang.bitstring_to_list
    d = pld_pad |> :erlang.bitstring_to_list

    for i <- 0..k * 16 - (16 - pld_size) - 1 do
      Enum.at(d, i) ^^^ Enum.at(s, i)
    end
  end
end
