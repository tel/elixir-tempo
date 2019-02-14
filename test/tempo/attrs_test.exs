defmodule Tempo.AttrsTest do
  use ExUnit.Case, async: true
  doctest Tempo.Attrs, import: true

  alias Tempo.Attrs

  defp render_value(v) do
    iodata = Attrs.render_value(v)
    IO.iodata_to_binary(iodata)
  end

  test "atom", do: assert(render_value(:foo) === "foo")
  test "atom (tricky)", do: assert(render_value(:"tricky atom") === "tricky atom")
  test "atom (escaping quotes)", do: assert(render_value(:"\"x\"") === "&quot;x&quot;")
  test "atom (escaping <)", do: assert(render_value(:"<x>") === "&lt;x&gt;")
  test "atom (escaping &)", do: assert(render_value(:"&x") === "&amp;x")

  test "string", do: assert(render_value("string") === "string")
  test "string (escaping quotes)", do: assert(render_value(~s{"x"}) === "&quot;x&quot;")
  test "string (escaping <)", do: assert(render_value("<x>") === "&lt;x&gt;")
  test "string (escaping &)", do: assert(render_value("&x") === "&amp;x")

  test "integer", do: assert(render_value(3) === "3")
  test "integer (negative)", do: assert(render_value(-3) === "-3")

  test "float", do: assert(render_value(3.0) === "3.0")
  test "float (negative)", do: assert(render_value(-3.0) === "-3.0")
  test "float (precise)", do: assert(render_value(3.000001) === "3.000001")

  test "list", do: assert(render_value([:foo, :bar]) === "foo bar")

  test "map" do
    assert(render_value(%{x: 3, y: true, z: false}) === "x y")
  end
end
