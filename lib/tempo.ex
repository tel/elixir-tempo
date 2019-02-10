defmodule Tempo do
  @moduledoc """
  Tempo, a library for writing "componentized" HTML templates.

  Tempo takes lessons from React's tree-based templating system to help
  construct "componentized" templates. Instead of glueing interpolated
  strings together with Tempo you construct domain-specific components which
  render fragments of HTML trees and glue them together into your entire
  page.
  """
  alias Tempo.Vdom

  @spec render(Vdom.t()) :: {:safe, iolist()}
  def render(vdom) do
    {:safe, Tempo.Vdom.render(vdom)}
  end
end
