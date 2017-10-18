defmodule Wildcard do
  @moduledoc """
  Wildcard is a module that can be used to interact with wildcard statements
  intended to match text
  """

  @doc """
  Converts an expression that can contain wildcards into a regex that can be
  used to match text. The resulting regex does not anchor to the beginning or
  end of the string using ^ or $. All non-wildcard text in the given expression
  is converted to raw text.

  ## Example

      iex> Wildcard.to_regex("man*pig")
      ~r/man.*pig/

  """
  def to_regex(expression) do
    {:ok, regex} = expression
      |> String.split("*")
      |> Enum.map(&Regex.escape(&1))
      |> Enum.join(".*")
      |> Regex.compile
    regex
  end
end
