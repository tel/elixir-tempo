defmodule Tempo.Attrs do
  @moduledoc """
  Attributes are named values encoded into HTML tag declarations. While
  attributes can have rich semantics, ultimately they all just become strings
  that are interpreted by both HTML renderers and humans.
  """

  @typedoc """
  The union Elixir types which can be rendered as an HTML attribute value.
  """
  @type value() ::
          atom()
          | String.t()
          | float()
          | integer()
          | [value()]
          | %{required(value()) => any()}
          | tuple()

  @typedoc """
  Union of possible attribute names.
  """
  @type name :: atom() | String.t()

  @doc """
  Render an Elixir value as an HTML attribute value. Assumes well-formed
  utf8 data at all points where binary data is embedded within the value.
  Returns iodata representing an escaped HTML attribute value.
  """
  @spec render_value(value()) :: iodata()
  def render_value(value), do: Tempo.Internal.AttrValue.render(value)
end
