defmodule Tempo.Internal do
  @moduledoc """
  Functionality primarily useful for the implementation of Tempo. Methods
  exported from this module are not considered part of the public interface
  and are subject to change without notification.
  """

  alias Tempo.Vdom

  @doc """
  Defines a new set of "tag" functions for a given name.
  """
  defmacro deftag(tag, doc) do
    tname = String.to_atom("t" <> Atom.to_string(tag))
    taname = String.to_atom("ta" <> Atom.to_string(tag))

    quote do
      @doc unquote(doc)
      @spec unquote(taname)([any()]) :: Vdom.t()
      def unquote(taname)(attrs) when is_list(attrs) do
        Vdom.el(unquote(tag), attrs, [])
      end

      @doc unquote(doc)
      @spec unquote(tname)() :: Vdom.t()
      def unquote(tname)(), do: Vdom.el(unquote(tag), [], [])

      @doc unquote(doc)
      @spec unquote(tname)([any()], Vdom.t() | [Vdom.t()]) :: Vdom.t()
      def unquote(tname)(attrs, children) when is_list(children) do
        Vdom.el(unquote(tag), attrs, children)
      end

      def unquote(tname)(attrs, child) do
        Vdom.el(unquote(tag), attrs, [child])
      end
    end
  end

  @doc """
  Escapes HTML entities from a string.
  """
  @spec escape(String.t()) :: String.t()
  def escape(string), do: HtmlEntities.encode(string)

  defprotocol AttrValue do
    @moduledoc """
    Anything which implements AttrValue can be treated as an attribute
    value. Note that valid implementations of this protocol must /escape/ the
    results.
    """

    @type t() :: Tempo.Attrs.value_type()

    @doc """
    Render an Elixir value as an HTML attribute value. Assumes well-formed
    utf8 data at all points where binary data is embedded within the value.
    Returns iodata representing an escaped HTML attribute value.
    """
    @spec render(t()) :: iodata()
    def render(x)
  end

  # Atom, BitString, Float, Function, Integer, List, Map, PID, Port, Reference, Tuple

  defimpl AttrValue, for: Atom do
    @doc """
    Atoms must be utf8, although they can contain HTML entities needing encoding
    """
    def render(atom), do: Tempo.Internal.escape(Atom.to_string(atom))
  end

  defimpl AttrValue, for: BitString do
    @doc """
    Arbitrary bitstrings need not be unicode, but GIGO. We'll escape any
    string, though.
    """
    def render(bitstring), do: Tempo.Internal.escape(bitstring)
  end

  defimpl AttrValue, for: Float do
    @doc """
    Uses default rendering for Floats.
    """
    def render(float), do: Float.to_string(float)
  end

  defimpl AttrValue, for: Integer do
    @doc """
    Assumes base 10.
    """
    def render(int), do: Integer.to_string(int)
  end

  defimpl AttrValue, for: List do
    @doc """
    A list assumes each element can be rendered as a value and the concatenates
    them with spaces. This is, e.g., convenient for classes.
    """
    def render(list) do
      # Based on implementation for Enum.join
      reduced =
        Enum.reduce(list, :first, fn
          entry, :first -> AttrValue.render(entry)
          entry, acc -> [acc, " " | AttrValue.render(entry)]
        end)

      if reduced == :first do
        ""
      else
        reduced
      end
    end
  end

  defimpl AttrValue, for: Map do
    @doc """
    Rendering a map as an HTML attribute value is similar to rendering its
    list of keys (e.g. from `Map.keys/1`), /but/ any key whose value is
    `false` is ignored.
    """
    def render(map) do
      good_keys = for {k, v} <- map, v, do: k
      AttrValue.render(good_keys)
    end
  end

  defimpl AttrValue, for: Tuple do
    @doc """
    Tuples are rendered as HTML attributes as if they were fixed sized lists.
    """
    def render(map) do
      AttrValue.render(Tuple.to_list(map))
    end
  end

  defprotocol AttrSet do
    @moduledoc """
    Anything which implements AttrSet can be treated as a whole set of named
    attributes. This is useful for passing structs directly into element
    definitions.
    """

    @spec to_map(t()) :: %{required(String.t()) => iodata()}
    def to_map(x)
  end

  defimpl AttrSet, for: List do
    def to_map(list), do: Map.new(Enum.map(list, fn {k, v} -> {k, AttrValue.render(v)} end))
  end

  defimpl AttrSet, for: Map do
    def to_map(map), do: AttrSet.to_map(Map.to_list(map))
  end
end
