defmodule ExDeribit.Instrument do
  alias __MODULE__

  @type t :: %Instrument{}

  defstruct ~w(
    kind
    base_currency
    currency
    min_trade_size
    min_trade_amount
    instrument_name
    is_active
    settlement
    created
    tick_size
    price_precision
    expiration
    contract_size
  )a
end
