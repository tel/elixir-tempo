defmodule Tempo.Vdom do
  @moduledoc """
  The Tempo "virtual dom" is an explicit, simplified representation of the
  DOM tree as eventually will be rendered in the browser. The simplified form
  is sufficient for constructing a static tree and allows for fast,
  concatenative construction of an HTML document.

  After a Vdom has been constructed it should be *rendered* into iodata for
  use.
  """

  alias Tempo.Internal
  alias Tempo.Attrs

  @typedoc """
  The Vdom type itself.
  """
  @opaque t() ::
            {:text, String.t()}
            | {:safe, iodata()}
            | {:element, atom(), any(), [t()]}
            | {:component, atom(), any()}

  @spec render(t()) :: iodata()
  def render(vdom) do
    case vdom do
      {:text, text} ->
        # Note: It'd be nice to use the same HTML escape algorithm as available in
        # Plug, e.g., but that's a huge dependency
        Internal.escape(text)

      {:safe, text} ->
        text

      {:element, tag, attrs, children} ->
        tag = Atom.to_string(tag)
        has_attrs = !Enum.empty?(attrs)
        has_children = !Enum.empty?(children)
        attrs = render_attr_set(attrs)
        children = Enum.map(children, &render/1)

        case {has_attrs, has_children} do
          {false, false} ->
            "<#{tag} />"

          {false, true} ->
            ["<#{tag}>", children, "</#{tag}>"]

          {true, false} ->
            ["<#{tag} ", attrs, " />"]

          {true, true} ->
            ["<#{tag} ", attrs, ">", children, "</#{tag}>"]
        end

      {:component, module, arg} ->
        render(module.render(arg))
    end
  end

  defp render_attr_set(maplike) do
    # Based on implementation for Enum.join
    reduced =
      Enum.reduce(maplike, :first, fn
        {k, v}, :first when is_atom(k) ->
          [Atom.to_string(k), ~s{="}, Attrs.render_value(v), ~s{"}]

        {k, v}, acc when is_binary(k) ->
          [acc, " ", k, ~s{="}, Attrs.render_value(v), ~s{"}]
      end)

    if reduced == :first do
      ""
    else
      reduced
    end
  end

  @spec text(String.t()) :: t()
  def text(string), do: {:text, string}

  @spec el(atom(), Attrs.t(), [t()]) :: t()
  def el(tag, attrs, children), do: {:element, tag, attrs, children}

  @spec unsafe_raw(iodata()) :: t()
  def unsafe_raw(iodata), do: {:safe, iodata}
end
