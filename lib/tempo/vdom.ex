defmodule Tempo.Vdom do
  @moduledoc """
  The Tempo "virtual dom" is an explicit, simplified representation of the
  DOM tree as eventually will be rendered in the browser. The simplified form
  is sufficient for constructing a static tree and allows for fast,
  concatenative construction of an HTML document.

  After a Vdom has been constructed it should be *rendered* into an iolist
  for use.
  """

  @doc """
  The Vdom type itself.
  """
  @opaque t() :: {:text, String.t()} | {:safe, iolist()} | {:element, atom(), [t()]}

  @spec render(t()) :: iolist()
  def render(vdom) do
    case vdom do
      {:text, text} ->
        # Note: It'd be nice to use the same HTML escape algorithm as available in
        # Plug, e.g., but that's a huge dependency
        HtmlEntities.encode(text)

      {:safe, text} ->
        text

      {:element, tag, children} ->
        tagname = Atom.to_string(tag)

        if Enum.empty?(children) do
          "<#{tagname} />"
        else
          ["<#{tagname}>", Enum.map(children, &render/1), "</#{tagname}>"]
        end
    end
  end

  @spec text(String.t()) :: t()
  def text(string), do: {:text, string}

  @spec el(atom(), [any()], [t()]) :: t()
  def el(tag, _attrs, children), do: {:element, tag, children}

  @spec unsafe_raw(iolist()) :: t()
  def unsafe_raw(iolist), do: {:safe, iolist}
end
