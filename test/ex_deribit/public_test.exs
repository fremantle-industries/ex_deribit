defmodule ExDeribit.PublicTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.Public

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get_instruments/1" do
    use_cassette "public/get_instruments" do
      {:ok, instruments} = ExDeribit.Public.get_instruments()
      assert Enum.count(instruments) != 0
      assert %ExDeribit.Instrument{} = instrument = Enum.at(instruments, 0)
      assert instrument.currency != nil
    end
  end
end
