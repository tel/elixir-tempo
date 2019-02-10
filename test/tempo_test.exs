defmodule TempoTest do
  use ExUnit.Case, async: true

  doctest Tempo, import: true

  import Tempo.Html

  defp render(vdom) do
    {:safe, iolist} = Tempo.render(vdom)
    IO.iodata_to_binary(iolist)
  end

  test "doctype", do: assert(render(doctype()) == "<!DOCTYPE html>")

  test "empty div tag example", do: assert(render(tdiv()) == "<div />")
  test "empty p tag example", do: assert(render(tp()) == "<p />")
  test "empty article tag example", do: assert(render(tarticle()) == "<article />")
  test "empty video tag example", do: assert(render(tvideo()) == "<video />")

  test "handles safe and unsafe text" do
    example = "<foo></bar>"
    mangled = "&lt;foo&gt;&lt;/bar&gt;"
    assert(render(text(example)) == mangled)
  end
end
