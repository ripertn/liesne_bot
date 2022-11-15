defmodule LiesneBotTest do
  use ExUnit.Case
  doctest LiesneBot

  test "greets the world" do
    assert LiesneBot.hello() == :world
  end
end
