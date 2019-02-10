# Tempo

**Component-based HTML templating library**

## Overview

In practice, web pages are composed of a number of "components": repeating
blocks of tags and styles which _go together_. Tempo is a tool for
constructing web pages in a component-based style.

Components _encapsulate_ private information like HTML tag structure and CSS
class names. They also _reduce API surface area_ noting that while HTML and
CSS as languages are very expressive, in any actual app we work with a small
number of controlled permutations.

String-based templating libraries like IEx are more flexible than Tempo, but
they expose the full complexity of the web page. This makes reuse of
templating code more difficult and incentivizes manual conventions like BEM
to avoid mixing private details.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be
installed by adding `tempo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tempo, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and published on
[HexDocs](https://hexdocs.pm). Once published, the docs can be found at
[https://hexdocs.pm/tempo](https://hexdocs.pm/tempo).

## Development

Run tests on watch using `mix test.watch`.

Check style compliance with `mix credo`.
