defmodule ExDeribit.Accounts.PositionTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.Accounts.Position

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExDeribit.Credentials{
    client_id: System.get_env("DERIBIT_CLIENT_ID"),
    client_secret: System.get_env("DERIBIT_CLIENT_SECRET")
  }

  test ".get/2" do
    use_cassette "accounts/get_position_ok" do
      assert {:ok, position} = ExDeribit.Accounts.Position.get(@credentials, "BTC-PERPETUAL")
      assert position.instrument_name == "BTC-PERPETUAL"
    end
  end
end
