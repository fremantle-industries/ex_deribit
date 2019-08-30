defmodule ExDeribit.JsonRpcResponse do
  alias __MODULE__

  @type t :: %JsonRpcResponse{
          message: String.t(),
          result: map | list,
          success: boolean,
          testnet: boolean,
          us_diff: integer,
          us_in: integer,
          us_out: integer,
          error: integer | nil
        }

  defstruct ~w(message result success testnet us_diff us_in us_out error)a
end
