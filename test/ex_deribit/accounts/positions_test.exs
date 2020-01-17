defmodule ExDeribit.Accounts.PositionsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.Accounts.Summary

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExDeribit.Credentials{
    client_id: System.get_env("DERIBIT_CLIENT_ID"),
    client_secret: System.get_env("DERIBIT_CLIENT_SECRET")
  }

  test ".get/2" do
    use_cassette "accounts/get_positions_ok" do
      assert {:ok, positions} = ExDeribit.Accounts.Positions.get(@credentials, "BTC")
      assert Enum.count(positions) > 0

      position = Enum.at(positions, 0)
      assert position.instrument_name != nil
    end
  end
end
