defmodule ExDeribit.Accounts.AnnouncementsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExDeribit.Accounts.Announcements

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/0 returns a list of announcements" do
    use_cassette "accounts/get_announcements_ok" do
      assert {:ok, announcements} = ExDeribit.Accounts.Announcements.get()
      assert Enum.count(announcements) > 0

      announcement = Enum.at(announcements, 0)
      assert announcement.title != nil
    end
  end

  test ".get/1 can filter by starting timestamp & count" do
    use_cassette "accounts/get_announcements_with_opts_ok" do
      start = Timex.now() |> DateTime.to_unix(:millisecond)

      assert {:ok, announcements} =
               ExDeribit.Accounts.Announcements.get(%{start_timestamp: start, count: 1})

      assert Enum.count(announcements) == 1
    end
  end
end
