defmodule ExDeribit.Public do
  alias ExDeribit.HTTPClient

  @type currency :: :btc | :eth
  @type opts :: %{
          optional(:kind) => :future | :option,
          optional(:expired) => boolean
        }
  @type instrument :: ExDeribit.Instrument.t()
  @type result :: {:ok, [instrument]} | {:error, :parse_result_item_to_instrument}

  @path "/public/get_instruments"
  @currencies ~w(btc eth)a

  @spec get_instruments(currency) :: result
  @spec get_instruments(currency, opts) :: result
  def get_instruments(currency, opts \\ %{}) when currency in @currencies do
    venue_currency = currency |> to_venue_currency()
    params = Map.put(opts, :currency, venue_currency)

    @path
    |> HTTPClient.non_auth_get(params)
    |> parse_response()
  end

  defp parse_response({:ok, %ExDeribit.JsonRpcResponse{result: instruments}}) do
    instruments
    |> Enum.map(&Mapail.map_to_struct(&1, ExDeribit.Instrument, transformations: [:snake_case]))
    |> Enum.reduce(
      {:ok, []},
      fn
        {:ok, i}, {:ok, acc} -> {:ok, [i | acc]}
        _, _acc -> {:error, :parse_result_item_to_instrument}
      end
    )
  end

  defp to_venue_currency(:btc), do: "BTC"
  defp to_venue_currency(:eth), do: "ETH"
end
