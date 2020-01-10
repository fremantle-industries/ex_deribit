defmodule ExDeribit.Instrument do
  alias __MODULE__

  @type t :: %Instrument{
          tick_size: number,
          taker_commission: number,
          settlement_period: String.t(),
          quote_currency: String.t(),
          min_trade_amount: number,
          maker_commission: number,
          leverage: number,
          kind: String.t(),
          is_active: boolean,
          instrument_name: String.t(),
          expiration_timestamp: pos_integer,
          creation_timestamp: pos_integer,
          contract_size: pos_integer,
          base_currency: String.t()
        }

  defstruct ~w(
    tick_size
    taker_commission
    settlement_period
    quote_currency
    min_trade_amount
    maker_commission
    leverage
    kind
    is_active
    instrument_name
    expiration_timestamp
    creation_timestamp
    contract_size
    base_currency
  )a
end
