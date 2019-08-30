defmodule ExDeribit.HTTPClient do
  @type verb :: :get | :post | :put | :delete
  @type params :: map
  @type path :: String.t()
  @type non_auth_response :: term
  @type auth_required :: :auth_required

  @protocol Application.get_env(:ex_bitmex, :rest_protocol, "https://")
  @domain Application.get_env(:ex_bitmex, :domain, "www.deribit.com")
  @api_path Application.get_env(:ex_bitmex, :api_path, "/api/v1")
  @origin @protocol <> @domain

  @spec domain :: String.t()
  def domain, do: @domain

  @spec non_auth_get(path, params) :: non_auth_response
  def non_auth_get(path, params \\ %{}) do
    non_auth_request(:get, path, params)
  end

  @spec non_auth_request(verb, path :: String.t(), params) :: non_auth_response
  def non_auth_request(verb, path, params) do
    body = Jason.encode!(params)
    headers = [] |> put_content_type(:json)

    %HTTPoison.Request{
      method: verb,
      url: path |> url,
      headers: headers,
      body: body
    }
    |> send
  end

  @spec auth_get(path, params) :: non_auth_response
  def auth_get(path, params \\ %{}) do
    auth_request(:get, path, params)
  end

  @spec auth_request(verb, path :: String.t(), params) :: non_auth_response
  def auth_request(verb, path, params) do
    body = Jason.encode!(params)
    headers = [] |> put_content_type(:json)

    %HTTPoison.Request{
      method: verb,
      url: path |> url,
      headers: headers,
      body: body
    }
    |> send
    |> parse_auth_response
  end

  @spec url(path :: String.t()) :: String.t()
  def url(path), do: @origin <> @api_path <> path

  defp put_content_type(headers, :json) do
    Keyword.put(headers, :"Content-Type", "application/json")
  end

  defp send(request) do
    request
    |> HTTPoison.request()
    |> parse_response
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, json} = Jason.decode(body)

    {:ok, rpc_response} =
      Mapail.map_to_struct(json, ExDeribit.JsonRpcResponse, transformations: [:snake_case])

    {:ok, rpc_response}
  end

  def parse_auth_response(
        {:ok,
         %ExDeribit.JsonRpcResponse{
           success: false,
           message: "authorization_required",
           error: 10000
         }}
      ) do
    {:error, :auth_required}
  end
end
