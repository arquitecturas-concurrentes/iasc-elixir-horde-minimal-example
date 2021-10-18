defmodule IascElixirHordeMinimalExampleTest do
  use ExUnit.Case
  doctest IascElixirHordeMinimalExample

  test "greets the world" do
    assert IascElixirHordeMinimalExample.hello() == :world
  end
end
