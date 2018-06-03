defmodule NamedPipeExample do
  @moduledoc """
  Documentation for NamedPipeExample.
  """

  @doc """
  Show message.
  """
  def run(message) do
    path = "/tmp/pipe"
    case NamedPipeExampleNif.run(path, message) do
      :ok ->
        IO.puts("Elixir: will File open.")
        case File.open path, [:read] do
          {:ok, file} ->
            IO.puts("Elixir: File is opened.")
            case IO.read(file, :all) do
              {:ok, body} -> IO.puts(body)
              {:error, _} -> IO.puts("IO.read error!")
            end
            File.close(file)
          {:error, e} -> IO.puts("File.open error!")
        end
      _ -> IO.puts("nif error!")
    end
  end
end
