defmodule ExDeribit.PrivateTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.Private

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".account/1" do
    use_cassette "private/account" do
      assert {:ok, account} = ExDeribit.Private.account(true)
    end
  end
end
