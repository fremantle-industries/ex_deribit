defmodule ExDeribit.HttpClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.Private

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe ".auth_request/4" do
    test "returns an error tuple with invalid credentials" do
      use_cassette "http_client/auth_request_error_auth_required" do
        assert ExDeribit.HTTPClient.auth_request(:get, "/private/account", %{}) ==
                 {:error, :auth_required}
      end
    end
  end
end
