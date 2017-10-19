defmodule Wildcard do
  @moduledoc """
  Provides functions for dealing with wildcard expressions which are intended to
  match agains strings.

  A wildcard expression is a string that contains `*` characters which indicate
  that any text can be substituted at the location of the `*` characters. An
  example of a wildcard expression would be `"ch*se"`, which would match
  `"cheese"`, but not `"cats"`.

  ## Options

  The following options can be specified for the functions in the Wildcard
  module:

    * `match_type` - determines what will be matched by a wildcard character.
      The default is `:one_or_more`
      * `:one_or_more` - Matches one or more characters.
      * `:zero_or_more` - Matches any number of characters or none at all.
      * `:one` - Matches exactly one character.
  """

  @doc """
  Converts an expression that can contain wildcards into a regex that can be
  used to match text.

  The resulting regex does not anchor to the beginning or
  end of the string using ^ or $. All non-wildcard text in the given expression
  is converted to raw text.

  ## Examples

      iex> Wildcard.to_regex("man*pig")
      ~r/man.+pig/

      iex> Wildcard.to_regex("man*pig", match_type: :zero_or_more)
      ~r/man.*pig/

      iex> Wildcard.to_regex("man****pig", match_type: :one)
      ~r/man....pig/

  """
  @spec to_regex(String.t, Keyword.t) :: Regex.t
  def to_regex(expression, opts \\ []) do
    match_type = Keyword.get(opts, :match_type)

    {:ok, regex} = expression
      |> String.split("*")
      |> Enum.map(&Regex.escape(&1))
      |> maybe_filter_empties(match_type)
      |> join_with_quantifier(match_type)
      |> Regex.compile
    regex
  end

  @spec maybe_filter_empties([String.t], Keyword.t) :: [String.t]
  defp maybe_filter_empties(list, :zero_or_more) do
    Enum.filter(list, &(&1 != ""))
  end
  defp maybe_filter_empties(list, _), do: list

  defp join_with_quantifier(list, :zero_or_more), do: Enum.join(list, ".*")
  defp join_with_quantifier(list, :one), do: Enum.join(list, ".")
  defp join_with_quantifier(list, _), do: Enum.join(list, ".+")
end
