defmodule ComponentTest do
  use ExUnit.Case, async: true

  defmodule Box do
    use Tempo.Component
    import Tempo.Html

    def render(_ignored) do
      tdiv([], tp([], text("Hello!")))
    end
  end

  test "check" do
    vdom = {:component, Box, nil}
    {:safe, iodata} = Tempo.render(vdom)
    rendered = IO.iodata_to_binary(iodata)
    assert(rendered === "<div><p>Hello!</p></div>")
  end
end
