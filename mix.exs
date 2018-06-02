defmodule NamedPipeExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :named_pipe_example,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp rustler_crates() do
    [named_pipe_example: [
      path: "native/named_pipe_example_nif",
      mode: :release,
    ]]
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
      {:rustler, "~> 0.16.0"}
    ]
  end
end
