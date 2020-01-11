defmodule ExDeribit.Accounts.SummaryTest do
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

  test ".get/1" do
    use_cassette "accounts/get_account_summary_ok" do
      assert {:ok, summary} = ExDeribit.Accounts.Summary.get("BTC", @credentials)
      assert summary.currency != nil
    end
  end
end
