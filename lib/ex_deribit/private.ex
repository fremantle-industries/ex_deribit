defmodule ExDeribit.Private do
  alias ExDeribit.HTTPClient

  @type currency :: String.t()
  @type account :: ExDeribit.Account
  @type base_error_reason :: :timeout
  # | service_unavailable
  # | :not_found
  # | bad_request
  # | :overloaded
  @type auth_required :: HTTPClient.auth_required()
  @type auth_error_reason :: base_error_reason | :auth_required

  @spec account(boolean, currency) :: {:ok, account} | {:error, auth_error_reason}
  def account(ext, currency \\ "BTC") do
    "/private/account"
    |> HTTPClient.auth_get(%{ext: ext, currency: currency})
    |> parse_response()
  end

  defp parse_response({:ok, %ExDeribit.JsonRpcResponse{success: true, result: result}}) do
    result
    |> Mapail.map_to_struct(ExDeribit.Account, transformations: [:snake_case])
    |> case do
      {:ok, _} = r -> r
      _ -> {:error, :parse_result}
    end
  end

  defp parse_response({:error, _} = error), do: error
end
