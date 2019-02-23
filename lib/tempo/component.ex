defmodule Tempo.Component do
  @callback render(any()) :: Tempo.Vdom.t()

  defmacro __using__([]) do
    quote do
      @behavior Tempo.Component
    end
  end
end
