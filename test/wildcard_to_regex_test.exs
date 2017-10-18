defmodule WildcardTest do
  use ExUnit.Case
  doctest Wildcard

  import Wildcard

  describe "to_regex" do
    test "converts an empty string to an empty regex" do
      assert to_regex("") == ~r//
    end

    test "converts a standard string to a regex of that string" do
      assert to_regex("cats") == ~r/cats/
    end

    test "converts a string containing a wildcard to the appropriate regex" do
      assert to_regex("cat*dog") == ~r/cat.*dog/
    end

    test "properly escapes a string containing a special regex operator" do
      assert to_regex("cat.dog/+") == ~r/cat\.dog\/\+/
    end
  end
end
