defmodule NamedPipeExample do
  @moduledoc """
  Documentation for NamedPipeExample.
  """

  @doc """
  Show message.
  """
  def run(message) do
    path = 'myfile'
    NamedPipeExampleNif.run(path, message)
    pid = Port.open(path, [{:line, 4096}, :eof])
    receive do
      {^pid, {:data, content}} ->
        IO.puts(content)
    end
  end
end
