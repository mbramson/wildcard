defmodule Wildcard.Mixfile do
  use Mix.Project

  def project do
    [
      app: :wildcard,
      version: "0.2.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Wildcard",
      source_url: "https://github.com/mbramson/wildcard"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end

  defp description() do
    """
    Wildcard is a utility package for interacting with wildcard expressions which
    are intended to be matched against strings.
    """
  end

  defp package() do
    [
      name: "wildcard",
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Mathew Bramson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mbramson/wildcard"}
    ]
  end
end
