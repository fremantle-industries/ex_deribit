defmodule ExDeribit.Auth do
  def sign(client_secret, timestamp, nonce, http_method, uri, body) do
    request_data = [http_method, uri, body, ""] |> Enum.join("\n")
    string_to_sign = [timestamp, nonce, request_data] |> Enum.join("\n")

    :sha256
    |> :crypto.hmac(client_secret, string_to_sign)
    |> Base.encode16()
  end

  def nonce, do: :crypto.strong_rand_bytes(4) |> Base.encode16()
  def timestamp, do: :os.system_time(:millisecond)
end
