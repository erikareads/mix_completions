defmodule MixCompletions.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_completions,
      version: "0.3.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: "Mix task for generating shell completions for mix",
      source_url: "https://github.com/erikareads/mix_completions",
      package: [
        licenses: ["Apache-2.0"],
        links: %{
          GitHub: "https://github.com/erikareads/mix_completions"
        }
      ],
      deps: deps()
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
    []
  end
end
