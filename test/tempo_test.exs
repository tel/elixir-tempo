defmodule TempoTest do
  use ExUnit.Case, async: true

  doctest Tempo, import: true

  import Tempo.Html

  defp render(vdom) do
    {:safe, iodata} = Tempo.render(vdom)
    IO.iodata_to_binary(iodata)
  end

  test "doctype", do: assert(render(doctype()) === "<!DOCTYPE html>")

  describe "empty tag" do
    test "div tag", do: assert(render(tdiv()) === "<div />")
    test "p tag", do: assert(render(tp()) === "<p />")
    test "article tag", do: assert(render(tarticle()) === "<article />")
    test "video tag", do: assert(render(tvideo()) === "<video />")
  end

  describe "empty tag with attrs" do
    test "example 1" do
      assert(render(tdiv(class: %{active: true})) === ~s{<div class="active" />})
    end
  end

  test "nested divs" do
    tree = tdiv([], [tdiv(), tdiv()])
    expected = "<div><div /><div /></div>"
    assert(render(tree) === expected)
  end

  test "nested divs with attributes" do
    tree = tdiv([class: "outer"], [tdiv(class: "inner1"), tdiv(class: "inner2")])
    expected = ~s{<div class="outer"><div class="inner1" /><div class="inner2" /></div>}
    assert(render(tree) === expected)
  end

  test "handles safe and unsafe text" do
    example = "<foo></bar>"
    mangled = "&lt;foo&gt;&lt;/bar&gt;"
    assert(render(text(example)) === mangled)
  end
end
