defmodule ExDeribit.MarketData.CurrenciesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.MarketData.Currencies

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/0" do
    use_cassette "public/get_currencies_ok" do
      assert {:ok, currencies} = ExDeribit.MarketData.Currencies.get()
      assert Enum.count(currencies) != 0
      assert %ExDeribit.Currency{} = currency = Enum.at(currencies, 0)
      assert currency.currency != nil
    end
  end
end
