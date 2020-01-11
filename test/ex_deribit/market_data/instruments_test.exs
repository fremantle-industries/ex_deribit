defmodule ExDeribit.MarketData.InstrumentsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.MarketData.Instruments

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1" do
    use_cassette "market_data/get_instruments_ok" do
      assert {:ok, instruments} = ExDeribit.MarketData.Instruments.get("BTC")
      assert Enum.count(instruments) != 0
      assert %ExDeribit.Instrument{} = instrument = Enum.at(instruments, 0)
      assert instrument.base_currency != nil
    end
  end
end
