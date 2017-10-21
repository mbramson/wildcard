defmodule WildcardTest do
  use ExUnit.Case
  doctest Wildcard

  import Wildcard

  describe "matches?/2" do
    test "empty string matches against an empty string match expression" do
      assert matches?("", "")
    end

    test "string matches literal string" do
      assert matches?("dog", "dog")
    end

    test "does not match when not a substring" do
      refute matches?("cat", "dog")
    end

    test "string matches substring match expression" do
      assert matches?("abso lutely", "lute")
    end

    test "string matches a match expression containing a wildcard" do
      assert matches?("at least five things", "at least * things")
    end

    test "matches? can pass through options" do
      refute matches?("manpig", "man*pig", match_type: :one_or_more)
      assert matches?("manpig", "man*pig", match_type: :zero_or_more)
    end
  end

  describe "to_regex/1" do
    test "converts an empty string to an empty regex" do
      assert to_regex("") == ~r//
    end

    test "converts a standard string to a regex of that string" do
      assert to_regex("cats") == ~r/cats/
    end

    test "converts a string containing a wildcard to the appropriate regex" do
      assert to_regex("cat*dog") == ~r/cat.+dog/
    end

    test "properly escapes a string containing a special regex operator" do
      assert to_regex("cat.dog/+") == ~r/cat\.dog\/\+/
    end

    test "generates regex matching zero or more if the match_type is :zero_or_more" do
      assert to_regex("cat*dog", match_type: :zero_or_more) == ~r/cat.*dog/
    end

    test "treats consecutive wildcards as one if the match_type is :zero_or_more" do
      assert to_regex("cat***dog", match_type: :zero_or_more) == ~r/cat.*dog/
    end

    test "does not treat consecutive wildcards as one if match type is :one_or_more" do
      assert to_regex("cat**dog")                           == ~r/cat.+.+dog/
      assert to_regex("cat**dog", match_type: :one_or_more) == ~r/cat.+.+dog/
    end

    test "genereates a regex matching one character if match_type is :one" do
      assert to_regex("cat*dog", match_type: :one)  == ~r/cat.dog/
      assert to_regex("cat**dog", match_type: :one) == ~r/cat..dog/
    end
  end
end
