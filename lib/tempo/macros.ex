defmodule Tempo.Macros do
  @moduledoc """
  Convenience macros for Tempo. Most likely you will not need to import this module.
  """

  alias Tempo.Vdom

  @doc """
  Defines a new set of "tag" functions for a given name.
  """
  defmacro deftag(tag, doc) do
    fun_name = String.to_atom("t" <> Atom.to_string(tag))

    quote do
      @doc unquote(doc)
      @spec unquote(fun_name)() :: Vdom.t()
      def unquote(fun_name)(), do: Vdom.el(unquote(tag), [], [])

      @doc unquote(doc)
      @spec unquote(fun_name)([any()]) :: Vdom.t()
      def unquote(fun_name)(attrs), do: Vdom.el(unquote(tag), attrs, [])

      @doc unquote(doc)
      @spec unquote(fun_name)([any()], [Vdom.t()]) :: Vdom.t()
      def unquote(fun_name)(attrs, children), do: Vdom.el(unquote(tag), attrs, children)
    end
  end
end
